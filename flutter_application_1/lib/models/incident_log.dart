import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


/// Types of incidents that can be logged
enum IncidentType {
  fall,        // سقوط
  highTremor,  // ارتعاش عالي
  manualSOS,   // استدعاء يدوي
  lowBattery,  // بطارية منخفضة
  disconnected,// انقطاع اتصال
  medication,  // دواء مأخوذ
}

/// Severity levels for incidents
enum IncidentSeverity {
  low,      // منخفض
  medium,   // متوسط
  high,     // عالي
  critical, // حرج
}

/// Incident Log Model for tracking health events
/// Stores information about tremor events, falls, SOS calls, etc.
///
/// Features:
/// ✅ Unique ID for each incident
/// ✅ Type classification (fall, tremor, SOS, etc.)
/// ✅ Severity levels
/// ✅ Resolution tracking
/// ✅ Detailed descriptions
@HiveType(typeId: 3)
class IncidentLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type; // FALL, HIGH_TREMOR, MANUAL_SOS, etc.

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final double severity; // 0.0 - 1.0

  @HiveField(4)
  final bool isResolved;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final double? frequency; // Tremor frequency

  @HiveField(7)
  final double? amplitude; // Tremor amplitude

  @HiveField(8)
  final int? heartRate; // Heart rate at time of incident

  @HiveField(9)
  final Map<String, dynamic>? additionalData;

  IncidentLog({
    String? id,
    required this.type,
    required this.timestamp,
    required this.severity,
    this.isResolved = false,
    this.description,
    this.frequency,
    this.amplitude,
    this.heartRate,
    this.additionalData,
  }) : id = id ?? const Uuid().v4();

  /// Get severity label
  String getSeverityLabel() {
    if (severity >= 0.75) return 'Critical';
    if (severity >= 0.5) return 'High';
    if (severity >= 0.25) return 'Medium';
    return 'Low';
  }

  /// Get incident type label
  String getTypeLabel() {
    switch (type) {
      case 'FALL':
        return 'Fall Detected';
      case 'HIGH_TREMOR':
        return 'High Tremor';
      case 'MANUAL_SOS':
        return 'Emergency Call';
      case 'LOW_BATTERY':
        return 'Low Battery';
      case 'DISCONNECTED':
        return 'Connection Lost';
      case 'MEDICATION':
        return 'Medication Taken';
      default:
        return 'Unknown';
    }
  }

  /// Format timestamp to readable string
  String getFormattedTime() {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity,
      'isResolved': isResolved,
      'description': description,
      'frequency': frequency,
      'amplitude': amplitude,
      'heartRate': heartRate,
      'additionalData': additionalData,
    };
  }

  /// Create from Map
  factory IncidentLog.fromMap(Map<String, dynamic> map) {
    return IncidentLog(
      id: map['id'] as String? ?? const Uuid().v4(),
      type: map['type'] as String,
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
      severity: (map['severity'] as num?)?.toDouble() ?? 0.0,
      isResolved: map['isResolved'] as bool? ?? false,
      description: map['description'] as String?,
      frequency: (map['frequency'] as num?)?.toDouble(),
      amplitude: (map['amplitude'] as num?)?.toDouble(),
      heartRate: map['heartRate'] as int?,
      additionalData: map['additionalData'] as Map<String, dynamic>?,
    );
  }

  /// Create a copy with modifications
  IncidentLog copyWith({
    String? id,
    String? type,
    DateTime? timestamp,
    double? severity,
    bool? isResolved,
    String? description,
    double? frequency,
    double? amplitude,
    int? heartRate,
    Map<String, dynamic>? additionalData,
  }) {
    return IncidentLog(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      severity: severity ?? this.severity,
      isResolved: isResolved ?? this.isResolved,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      amplitude: amplitude ?? this.amplitude,
      heartRate: heartRate ?? this.heartRate,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  String toString() => 'IncidentLog('
      'id: $id, '
      'type: $type, '
      'severity: $severity, '
      'isResolved: $isResolved'
      ')';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentLog &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Adapter for Hive serialization
class IncidentLogAdapter extends TypeAdapter<IncidentLog> {
  @override
  final int typeId = 3;

  @override
  IncidentLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }
    return IncidentLog(
      id: fields[0] as String,
      type: fields[1] as String,
      timestamp: DateTime.parse(fields[2] as String),
      severity: (fields[3] as num).toDouble(),
      isResolved: fields[4] as bool? ?? false,
      description: fields[5] as String?,
      frequency: (fields[6] as num?)?.toDouble(),
      amplitude: (fields[7] as num?)?.toDouble(),
      heartRate: fields[8] as int?,
      additionalData: fields[9] as Map<String, dynamic>?,
    );
  }

  @override
  void write(BinaryWriter writer, IncidentLog obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.timestamp.toIso8601String())
      ..writeByte(3)
      ..write(obj.severity)
      ..writeByte(4)
      ..write(obj.isResolved)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.frequency)
      ..writeByte(7)
      ..write(obj.amplitude)
      ..writeByte(8)
      ..write(obj.heartRate)
      ..writeByte(9)
      ..write(obj.additionalData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
