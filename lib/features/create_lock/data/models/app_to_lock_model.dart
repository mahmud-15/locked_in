import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';

class AppToLockModel extends AppToLockEntity {
  const AppToLockModel({
    required super.id,
    required super.name,
    required super.category,
    required super.iconKey,
    super.iconBytes,
  });

  factory AppToLockModel.fromJson(Map<String, dynamic> json) => AppToLockModel(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    iconKey: json['iconKey'] as String,
    iconBytes: json['iconBytes'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'iconKey': iconKey,
  };
}
