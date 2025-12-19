import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tremor_ring_app/models/emergency_model.dart';
import 'package:tremor_ring_app/services/notification_service.dart';

class EmergencyService extends ChangeNotifier {
  bool _isEmergencyActive = false;
  List<EmergencyContact> _contacts = [];

  bool get isEmergencyActive => _isEmergencyActive;
  List<EmergencyContact> get contacts => _contacts;

  EmergencyService() {
    _initializeContacts();
  }

  Future<void> _initializeContacts() async {
    try {
      final box = await Hive.openBox<EmergencyContact>('emergency_contacts');
      _contacts = box.values.toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing contacts: $e');
    }
  }

  Future<void> addContact({
    required String name,
    required String phone,
    required String relation,
    bool isPrimary = false,
  }) async {
    try {
      final contact = EmergencyContact(
        name: name,
        phone: phone,
        relation: relation,
        isPrimary: isPrimary,
      );

      final box = await Hive.openBox<EmergencyContact>('emergency_contacts');

      if (isPrimary) {
        for (var c in box.values) {
          if (c.isPrimary) {
            c.isPrimary = false;
            c.save();
          }
        }
      }

      await box.add(contact);
      await _initializeContacts();
    } catch (e) {
      debugPrint('Error adding contact: $e');
    }
  }

  Future<void> deleteContact(int index) async {
    try {
      final box = await Hive.openBox<EmergencyContact>('emergency_contacts');
      await box.deleteAt(index);
      await _initializeContacts();
    } catch (e) {
      debugPrint('Error deleting contact: $e');
    }
  }

  Future<void> makeEmergencyCall({required String phoneNumber}) async {
    try {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(launchUri)) {
        await _triggerEmergencyAlarm();
        await launchUrl(launchUri);
        await _logIncident(
          type: 'MANUAL_SOS',
          severity: 1.0,
          description: 'اتصال طوارئ يدوي',
        );
      }
    } catch (e) {
      debugPrint('Error making emergency call: $e');
    }
  }

  Future<void> _triggerEmergencyAlarm() async {
    _isEmergencyActive = true;
    notifyListeners();

    for (int i = 0; i < 5; i++) {
      await Vibration.vibrate(duration: 500);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    await NotificationService.playEmergencySound();
    await NotificationService.showEmergencyNotification(
      title: 'تنبيه طوارئ نشط!',
      body: 'تم تفعيل وضع الطوارئ',
    );
  }

  Future<void> cancelEmergency() async {
    _isEmergencyActive = false;
    notifyListeners();
    await NotificationService.cancelEmergency();
  }

  Future<void> _logIncident({
    required String type,
    double? severity,
    String? description,
  }) async {
    try {
      final incident = IncidentLog(
        timestamp: DateTime.now(),
        type: type,
        severity: severity,
        description: description,
      );

      final box = await Hive.openBox<IncidentLog>('incident_logs');
      await box.add(incident);
    } catch (e) {
      debugPrint('Error logging incident: $e');
    }
  }

  Future<List<IncidentLog>> getIncidentHistory({int limit = 50}) async {
    try {
      final box = await Hive.openBox<IncidentLog>('incident_logs');
      final logs = box.values.toList();
      logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return logs.take(limit).toList();
    } catch (e) {
      debugPrint('Error getting incident history: $e');
      return [];
    }
  }

  EmergencyContact? getPrimaryContact() {
    try {
      return _contacts.firstWhere((c) => c.isPrimary);
    } catch (e) {
      return null;
    }
  }

  Future<void> quickEmergencyCall() async {
    final primary = getPrimaryContact();
    if (primary != null) {
      await makeEmergencyCall(phoneNumber: primary.phone);
    }
  }
}