import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class AppToLockEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String iconKey;
  final Uint8List? iconBytes;

  const AppToLockEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.iconKey,
    this.iconBytes,
  });

  @override
  List<Object?> get props => [id, name, category, iconKey, iconBytes];
}
