import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:tremor_ring_app/services/emergency_service.dart';

class FallDetectionService extends ChangeNotifier {
  final EmergencyService emergencyService;

  double _lastAccelerationMagnitude = 0;
  bool _fallDetected = false;

  bool get fallDetected => _fallDetected;

  static const double fallThreshold = 35.0;

  FallDetectionService({required this.emergencyService}) {
    _initializeSensors();
  }

  void _initializeSensors() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      _processFallDetection(x: event.x, y: event.y, z: event.z);
    });
  }

  void _processFallDetection({
    required double x,
    required double y,
    required double z,
  }) {
    double magnitude = sqrt(x * x + y * y + z * z);
    _lastAccelerationMagnitude = magnitude;

    if (magnitude > fallThreshold && !_fallDetected) {
      _handleFallDetected();
    }

    if (magnitude < 15 && _fallDetected) {
      _fallDetected = false;
      notifyListeners();
    }
  }

  Future<void> _handleFallDetected() async {
    _fallDetected = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));

    if (_fallDetected) {
      await emergencyService.quickEmergencyCall();
    }
  }

  Future<void> cancelFallAlert() async {
    _fallDetected = false;
    await emergencyService.cancelEmergency();
    notifyListeners();
  }

  double getCurrentAcceleration() {
    return _lastAccelerationMagnitude;
  }
}
