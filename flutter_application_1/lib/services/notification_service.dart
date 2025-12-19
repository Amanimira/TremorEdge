import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> showEmergencyNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'emergency_channel',
      'Emergency Alerts',
      channelDescription: 'Critical emergency notifications',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(0, title, body, details);
  }

  static Future<void> showMedicationReminder({
    required String medicationName,
    required String dosage,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'medication_channel',
      'Medication Reminders',
      channelDescription: 'Medication reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      1,
      '💊 وقت الدواء!',
      '$medicationName - $dosage',
      details,
    );
  }

  static Future<void> playEmergencySound() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/emergency_alert.mp3');
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> stopEmergencySound() async {
    await _audioPlayer.stop();
  }

  static Future<void> cancelEmergency() async {
    await _notificationsPlugin.cancel(0);
    await stopEmergencySound();
  }
}