import 'package:flutter/material.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';
import 'package:locked_in/shared/widgets/app_icon_widget.dart';

class SelectableAppTile extends StatelessWidget {
  final AppToLockEntity app;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableAppTile({
    super.key,
    required this.app,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Row(
          children: [
            AppIconWidget(app: app),
            const SizedBox(width: 14),
            Expanded(
              child: _AppInfo(name: app.name, category: app.category),
            ),
            _SelectionCircle(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _AppInfo extends StatelessWidget {
  final String name;
  final String category;
  const _AppInfo({required this.name, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          category,
          style: const TextStyle(fontSize: 12, color: AppColors.gray),
        ),
      ],
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  final bool isSelected;
  const _SelectionCircle({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFFD0D0D0),
          width: 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 13, color: Colors.white)
          : null,
    );
  }
}
