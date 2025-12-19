import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class EmergencyContact extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String phone;

  @HiveField(2)
  late String relation;

  @HiveField(3)
  late bool isPrimary;

  @HiveField(4)
  late DateTime createdAt;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.relation,
    this.isPrimary = false,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }
}

@HiveType(typeId: 1)
class IncidentLog extends HiveObject {
  @HiveField(0)
  late DateTime timestamp;

  @HiveField(1)
  late String type; // "FALL", "MANUAL_SOS", "HIGH_TREMOR"

  @HiveField(2)
  late double? severity; // 0.0 to 1.0

  @HiveField(3)
  late String? description;

  @HiveField(4)
  late bool isResolved;

  @HiveField(5)
  late String? resolvedNote;

  IncidentLog({
    required this.timestamp,
    required this.type,
    this.severity,
    this.description,
    this.isResolved = false,
    this.resolvedNote,
  });

  String get formattedTime {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year} - ${timestamp.hour}:${timestamp.minute}";
  }

  String get formattedDate {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
  }

  Color get severityColor {
    if (severity == null) return Colors.grey;
    if (severity! > 0.7) return Colors.red;
    if (severity! > 0.4) return Colors.orange;
    return Colors.yellow;
  }

  String get typeEmoji {
    switch (type) {
      case 'FALL':
        return '🚨';
      case 'MANUAL_SOS':
        return '🆘';
      case 'HIGH_TREMOR':
        return '⚠️';
      default:
        return '📋';
    }
  }
}

@HiveType(typeId: 2)
class TremorReading extends HiveObject {
  @HiveField(0)
  late DateTime timestamp;

  @HiveField(1)
  late double frequency; // Hz

  @HiveField(2)
  late double amplitude; // g

  @HiveField(3)
  late double confidence; // 0-100

  @HiveField(4)
  late String? type; // "Resting", "Essential", "Kinetic"

  TremorReading({
    required this.timestamp,
    required this.frequency,
    required this.amplitude,
    required this.confidence,
    this.type,
  });
}