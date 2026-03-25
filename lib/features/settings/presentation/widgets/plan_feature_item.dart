import 'package:flutter/material.dart';
import 'package:locked_in/core/constants/app_colors.dart';

class PlanFeatureItem extends StatelessWidget {
  final String feature;

  const PlanFeatureItem({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 11),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
