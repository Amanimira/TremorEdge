import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

class BLEService extends ChangeNotifier {
  final Logger _logger = Logger();
  
  BluetoothDevice? _connectedDevice;
  bool _isConnecting = false;
  bool _isConnected = false;
  bool _isScanning = false;
  
  List<BluetoothDevice> discoveredDevices = [];
  
  static const String serviceUUID = "12345678-1234-5678-1234-56789abcdef0";
  static const String tremorCharUUID = "12345678-1234-5678-1234-56789abcdef1";
  
  bool get isConnecting => _isConnecting;
  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  
  final ValueNotifier<TremorData?> tremorDataNotifier = ValueNotifier(null);
  
  Future<void> startScan({Duration timeout = const Duration(seconds: 4)}) async {
    try {
      _isScanning = true;
      notifyListeners();
      discoveredDevices.clear();
      
      await FlutterBluePlus.startScan(timeout: timeout);
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (result.device.platformName == "TremorRing" && 
              !discoveredDevices.contains(result.device)) {
            discoveredDevices.add(result.device);
            notifyListeners();
          }
        }
      });
      _logger.i("Scan started");
    } catch (e) {
      _logger.e("Scan error: $e");
      _isScanning = false;
      notifyListeners();
    }
  }
  
  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _logger.e("Stop scan error: $e");
    }
  }
  
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _isConnecting = true;
      notifyListeners();
      
      await device.connect();
      _connectedDevice = device;
      
      List<BluetoothService> services = await device.discoverServices();
      
      for (BluetoothService service in services) {
        if (service.uuid.toString().toUpperCase() == serviceUUID.toUpperCase()) {
          for (BluetoothCharacteristic char in service.characteristics) {
            if (char.uuid.toString() == tremorCharUUID) {
              await char.setNotifyValue(true);
              char.onValueReceived.listen(_handleTremorData);
            }
          }
        }
      }
      
      _isConnected = true;
      _isConnecting = false;
      notifyListeners();
      _logger.i("Connected to ${device.platformName}");
    } catch (e) {
      _isConnecting = false;
      _isConnected = false;
      notifyListeners();
      _logger.e("Connection error: $e");
    }
  }
  
  Future<void> disconnect() async {
    try {
      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
        _connectedDevice = null;
        _isConnected = false;
        notifyListeners();
      }
    } catch (e) {
      _logger.e("Disconnect error: $e");
    }
  }
  
  void _handleTremorData(List<int> value) {
    if (value.length < 28) return;
    
    try {
      final buffer = Uint8List.fromList(value);
      final byteData = ByteData.sublistView(buffer);
      
      final tremorType = byteData.getUint8(8);
      final frequency = byteData.getFloat32(9, Endian.little);
      final amplitude = byteData.getFloat32(13, Endian.little);
      final confidence = byteData.getUint8(17);
      final heartRate = byteData.getUint16(18, Endian.little);
      final temperature = byteData.getFloat32(20, Endian.little);
      
      tremorDataNotifier.value = TremorData(
        timestamp: DateTime.now(),
        tremorType: tremorType,
        frequency: frequency,
        amplitude: amplitude,
        confidence: confidence,
        heartRate: heartRate,
        temperature: temperature,
      );
    } catch (e) {
      _logger.e("Data parsing error: $e");
    }
  }
  
  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}

class TremorData {
  final DateTime timestamp;
  final int tremorType;
  final double frequency;
  final double amplitude;
  final int confidence;
  final int heartRate;
  final double temperature;
  
  TremorData({
    required this.timestamp,
    required this.tremorType,
    required this.frequency,
    required this.amplitude,
    required this.confidence,
    required this.heartRate,
    required this.temperature,
  });
  
  String get tremorTypeString {
    const types = ['Resting (PD)', 'Postural (ET)', 'Kinetic', 'Normal'];
    return types.length > tremorType ? types[tremorType] : 'Unknown';
  }
  
  String get riskLevel {
    if (tremorType == 3) return 'Normal';
    return confidence > 80 ? 'High Risk' : 'Medium Risk';
  }
}
