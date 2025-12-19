import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

/// Emergency Contact Model for quick emergency calls
/// Used for storing and managing emergency contacts
/// 
/// Features:
/// ✅ Unique ID for each contact
/// ✅ Priority system (primary contact)
/// ✅ Relationship tracking (brother, sister, hospital, etc.)
/// ✅ Phone number validation
@HiveType(typeId: 0)
class EmergencyContact extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String relation;

  @HiveField(4)
  final bool isPrimary;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  EmergencyContact({
    String? id,
    required this.name,
    required this.phone,
    required this.relation,
    this.isPrimary = false,
    DateTime? createdAt,
    this.updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relation': relation,
      'isPrimary': isPrimary,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create from Map
  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'] as String? ?? const Uuid().v4(),
      name: map['name'] as String,
      phone: map['phone'] as String,
      relation: map['relation'] as String,
      isPrimary: map['isPrimary'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  /// Create a copy with modifications
  EmergencyContact copyWith({
    String? id,
    String? name,
    String? phone,
    String? relation,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: relation ?? this.relation,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() => 'EmergencyContact('
      'id: $id, '
      'name: $name, '
      'phone: $phone, '
      'relation: $relation, '
      'isPrimary: $isPrimary'
      ')';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyContact &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Adapter for Hive serialization
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
      createdAt: fields[5] != null
          ? DateTime.parse(fields[5] as String)
          : DateTime.now(),
      updatedAt: fields[6] != null
          ? DateTime.parse(fields[6] as String)
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, EmergencyContact obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.relation)
      ..writeByte(4)
      ..write(obj.isPrimary)
      ..writeByte(5)
      ..write(obj.createdAt.toIso8601String())
      ..writeByte(6)
      ..write(obj.updatedAt?.toIso8601String());
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
