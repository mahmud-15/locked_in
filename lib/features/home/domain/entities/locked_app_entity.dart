import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class LockedAppEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final String lockedDuration;
  final String iconKey;
  final Uint8List? iconBytes;
  final DateTime lockUntil; // Restored lockUntil
  final String? userId; // Kept userId

  const LockedAppEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.lockedDuration,
    required this.iconKey,
    required this.lockUntil,
    this.iconBytes,
    this.userId, // Kept userId
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    lockedDuration,
    iconKey,
    iconBytes,
    lockUntil,
    userId, // Added userId
  ];
}
