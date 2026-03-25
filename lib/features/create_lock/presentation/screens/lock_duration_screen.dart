import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';
import 'package:locked_in/features/create_lock/presentation/providers/create_lock_notifier.dart';
import 'package:locked_in/features/create_lock/presentation/providers/create_lock_state.dart';
import 'package:locked_in/features/home/presentation/providers/home_notifier.dart';
import 'package:locked_in/shared/widgets/app_icon_widget.dart';

class LockDurationScreen extends ConsumerWidget {
  final List<AppToLockEntity> selectedApps;

  const LockDurationScreen({super.key, required this.selectedApps});

  static final List<String> _durations = List.generate(48, (index) {
    final minutes = (index + 1) * 30;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) return '$remainingMinutes min';
    if (remainingMinutes == 0) return '$hours hour${hours > 1 ? 's' : ''}';
    return '$hours h $remainingMinutes min';
  });

  void _showDurationPicker(
    BuildContext context,
    WidgetRef ref,
    String appId,
    int? currentDurationIndex,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Duration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF373737),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _durations.length,
                  itemBuilder: (context, index) {
                    final isSelected = currentDurationIndex == index;
                    return ListTile(
                      title: Text(
                        _durations[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFFFE5A4E)
                              : const Color(0xFF373737),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        ref
                            .read(createLockProvider.notifier)
                            .setDuration(appId, index);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createLockProvider);

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
              'Lock Duration',
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
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: selectedApps.length,
              itemBuilder: (context, index) {
                final app = selectedApps[index];
                final durationIndex = state.selectedAppDurations[app.id] ?? 0;
                return _AppDurationTile(
                  app: app,
                  selectedDuration: _durations[durationIndex],
                  onTap: () =>
                      _showDurationPicker(context, ref, app.id, durationIndex),
                );
              },
            ),
          ),
          _BottomButton(
            isLoading: state.status == CreateLockStatus.submitting,
            onPressed: () async {
              await ref.read(createLockProvider.notifier).confirmLock();
              final updatedState = ref.read(createLockProvider);
              if (updatedState.status == CreateLockStatus.success) {
                ref.read(homeProvider.notifier).loadData();
                context.goNamed(RouteNames.home);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _AppDurationTile extends StatelessWidget {
  final AppToLockEntity app;
  final String selectedDuration;
  final VoidCallback onTap;

  const _AppDurationTile({
    required this.app,
    required this.selectedDuration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconWidget(app: app),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      app.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle, color: Color(0xFFFE5A4E)),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Duration',
            style: TextStyle(fontSize: 12, color: Color(0xFF676E79)),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDuration,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF676E79),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            backgroundColor: const Color(0xFFFE5A4E),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
