import 'package:flutter/material.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/core/constants/app_strings.dart';

class CreateLockCard extends StatelessWidget {
  final VoidCallback onTap;

  const CreateLockCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _PlusIcon(),
            const SizedBox(width: 14),
            _CardLabel(),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.gray,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlusIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 22),
    );
  }
}

class _CardLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.createNewLock,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 2),
        Text(
          AppStrings.createNewLockSubtitle,
          style: TextStyle(fontSize: 12, color: AppColors.gray),
        ),
      ],
    );
  }
}
