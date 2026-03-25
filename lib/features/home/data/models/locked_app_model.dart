import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';

class LockedAppModel extends LockedAppEntity {
  const LockedAppModel({
    required super.id,
    required super.name,
    required super.category,
    required super.lockedDuration,
    required super.iconKey,
    required super.lockUntil,
    super.iconBytes,
  });

  factory LockedAppModel.fromJson(Map<String, dynamic> json) => LockedAppModel(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    lockedDuration: json['locked_duration'] as String,
    iconKey: json['icon_key'] as String,
    lockUntil: DateTime.parse(json['lock_until'] as String),
    iconBytes: json['icon_bytes'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'locked_duration': lockedDuration,
    'icon_key': iconKey,
    'lock_until': lockUntil.toIso8601String(),
    'icon_bytes': iconBytes,
  };
}
