import 'package:flutter/material.dart';

/// Represents a locked app entry
class LockedAppItem {
  final String name;
  final String category;
  final String time;
  final IconData icon;
  final Color iconColor;

  const LockedAppItem({
    required this.name,
    required this.category,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}
