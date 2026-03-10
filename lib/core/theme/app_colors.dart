import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF5247); // Coral/Red from onboarding
  static const Color secondary = Color(0xFF6200EE);
  static const Color background = Colors.white;
  static const Color splashBackground = Color(0xFFFBFBFB);
  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF757575);
  static const Color white800 = Color(0xFF818181);
  static const Color indicatorInactive = Color(0xFFE0E0E0);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF5247), Color(0xFFFF8A65)],
  );
}
