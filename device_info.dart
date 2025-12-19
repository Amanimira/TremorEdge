class DeviceInfo {
  final String name;
  final String address;
  final int signalStrength;
  final bool isConnected;
  final DateTime lastConnected;
  final String firmwareVersion;
  final String hardwareVersion;
  final int batteryLevel;
  
  DeviceInfo({
    required this.name,
    required this.address,
    required this.signalStrength,
    required this.isConnected,
    required this.lastConnected,
    required this.firmwareVersion,
    required this.hardwareVersion,
    required this.batteryLevel,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'signalStrength': signalStrength,
      'isConnected': isConnected,
      'lastConnected': lastConnected.millisecondsSinceEpoch,
      'firmwareVersion': firmwareVersion,
      'hardwareVersion': hardwareVersion,
      'batteryLevel': batteryLevel,
    };
  }
  
  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      signalStrength: map['signalStrength'] ?? 0,
      isConnected: map['isConnected'] ?? false,
      lastConnected: DateTime.fromMillisecondsSinceEpoch(map['lastConnected'] ?? 0),
      firmwareVersion: map['firmwareVersion'] ?? 'Unknown',
      hardwareVersion: map['hardwareVersion'] ?? 'Unknown',
      batteryLevel: map['batteryLevel'] ?? 0,
    );
  }
}
