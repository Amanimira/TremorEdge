import 'package:hive/hive.dart';

// ==================== Emergency Contact Model ====================

class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String relation;
  final bool isPrimary;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
    this.isPrimary = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relation': relation,
      'isPrimary': isPrimary,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      relation: map['relation'] ?? '',
      isPrimary: map['isPrimary'] ?? false,
    );
  }
}

class EmergencyContactAdapter extends TypeAdapter<EmergencyContact> {
  @override
  final int typeId = 0;

  @override
  EmergencyContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }
    return EmergencyContact(
      id: fields[0] as String,
      name: fields[1] as String,
      phone: fields[2] as String,
      relation: fields[3] as String,
      isPrimary: fields[4] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, EmergencyContact obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.relation)
      ..writeByte(4)
      ..write(obj.isPrimary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ==================== Incident Log Model ====================

class IncidentLog {
  final String id;
  final String type; // FALL, HIGH_TREMOR, MANUAL_SOS
  final DateTime timestamp;
  final double severity;
  final bool isResolved;
  final String? description;

  IncidentLog({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.severity,
    this.isResolved = false,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity,
      'isResolved': isResolved,
      'description': description,
    };
  }

  factory IncidentLog.fromMap(Map<String, dynamic> map) {
    return IncidentLog(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      severity: (map['severity'] ?? 0.0).toDouble(),
      isResolved: map['isResolved'] ?? false,
      description: map['description'],
    );
  }
}

class IncidentLogAdapter extends TypeAdapter<IncidentLog> {
  @override
  final int typeId = 1;

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
      severity: fields[3] as double,
      isResolved: fields[4] as bool? ?? false,
      description: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IncidentLog obj) {
    writer
      ..writeByte(6)
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
      ..write(obj.description);
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

// ==================== Tremor Reading Model ====================

class TremorReading {
  final String id;
  final DateTime timestamp;
  final double x;
  final double y;
  final double z;
  final double magnitude;

  TremorReading({
    required this.id,
    required this.timestamp,
    required this.x,
    required this.y,
    required this.z,
    required this.magnitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'x': x,
      'y': y,
      'z': z,
      'magnitude': magnitude,
    };
  }

  factory TremorReading.fromMap(Map<String, dynamic> map) {
    return TremorReading(
      id: map['id'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      x: (map['x'] ?? 0.0).toDouble(),
      y: (map['y'] ?? 0.0).toDouble(),
      z: (map['z'] ?? 0.0).toDouble(),
      magnitude: (map['magnitude'] ?? 0.0).toDouble(),
    );
  }
}

class TremorReadingAdapter extends TypeAdapter<TremorReading> {
  @override
  final int typeId = 2;

  @override
  TremorReading read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }
    return TremorReading(
      id: fields[0] as String,
      timestamp: DateTime.parse(fields[1] as String),
      x: fields[2] as double,
      y: fields[3] as double,
      z: fields[4] as double,
      magnitude: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TremorReading obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp.toIso8601String())
      ..writeByte(2)
      ..write(obj.x)
      ..writeByte(3)
      ..write(obj.y)
      ..writeByte(4)
      ..write(obj.z)
      ..writeByte(5)
      ..write(obj.magnitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TremorReadingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
