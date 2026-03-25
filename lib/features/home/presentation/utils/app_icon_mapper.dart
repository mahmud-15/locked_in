import 'package:flutter/material.dart';

/// Maps an iconKey string to its corresponding Flutter IconData + brand color.
/// Replace with actual SVG assets (e.g. from assets/icons/) when available.
class AppIconMapper {
  static ({IconData icon, Color color}) fromKey(String key) {
    switch (key) {
      case 'facebook':
        return (icon: Icons.facebook, color: const Color(0xFF1877F2));
      case 'youtube':
        return (icon: Icons.play_circle_fill, color: const Color(0xFFFF0000));
      case 'telegram':
        return (icon: Icons.send, color: const Color(0xFF26A5E4));
      case 'tiktok':
        return (icon: Icons.music_note, color: const Color(0xFF010101));
      case 'whatsapp':
        return (icon: Icons.chat_bubble, color: const Color(0xFF25D366));
      case 'instagram':
        return (icon: Icons.camera_alt, color: const Color(0xFFE1306C));
      case 'twitter':
        return (icon: Icons.alternate_email, color: const Color(0xFF1DA1F2));
      case 'messenger':
        return (icon: Icons.message, color: const Color(0xFF0084FF));
      default:
        return (icon: Icons.apps, color: const Color(0xFF9E9E9E));
    }
  }
}
