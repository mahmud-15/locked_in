import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';
import 'package:locked_in/features/create_lock/presentation/providers/create_lock_notifier.dart';
import 'package:locked_in/features/create_lock/presentation/providers/create_lock_state.dart';
import 'package:locked_in/features/home/presentation/utils/app_icon_mapper.dart';

class ReviewActiveScreen extends ConsumerWidget {
  final List<AppToLockEntity> selectedApps;

  const ReviewActiveScreen({super.key, required this.selectedApps});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createLockProvider);
    _handleStateChanges(context, ref, state);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review & Active',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'How should app be locked?',
              style: TextStyle(
                color: Color(0xFF676E79),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'Apps to lock',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ...selectedApps.map((app) => _AppReviewTile(app: app)),
                const SizedBox(height: 8),
                _AddNewButton(
                  onTap: () {
                    // Go back to CreateLockScreen
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          _BottomButton(
            onPressed: state.status == CreateLockStatus.submitting
                ? () {}
                : () {
                    ref.read(createLockProvider.notifier).confirmLock();
                  },
            isLoading: state.status == CreateLockStatus.submitting,
          ),
        ],
      ),
    );
  }

  void _handleStateChanges(
    BuildContext context,
    WidgetRef ref,
    CreateLockState state,
  ) {
    if (state.status == CreateLockStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(createLockProvider.notifier).resetStatus();
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }

    if (state.status == CreateLockStatus.failure &&
        state.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }
}

class _AppReviewTile extends StatelessWidget {
  final AppToLockEntity app;

  const _AppReviewTile({required this.app});

  @override
  Widget build(BuildContext context) {
    final iconData = AppIconMapper.fromKey(app.iconKey);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconData.color,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  app.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF676E79),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }
}

class _AddNewButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddNewButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Add New',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _BottomButton({required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      decoration: const BoxDecoration(color: Colors.white),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Activate Lock',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
