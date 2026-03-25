import 'package:flutter/material.dart';
import 'package:locked_in/core/constants/app_colors.dart';

class AppSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const AppSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: AppColors.black),
        decoration: const InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(fontSize: 14, color: AppColors.gray),
          prefixIcon: Icon(Icons.search, color: AppColors.gray, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
