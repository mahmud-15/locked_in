import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/features/create_lock/presentation/providers/create_lock_notifier.dart';
import 'package:locked_in/features/create_lock/presentation/providers/create_lock_state.dart';
import 'package:locked_in/features/create_lock/presentation/widgets/app_search_bar.dart';
import 'package:locked_in/features/create_lock/presentation/widgets/create_lock_app_bar.dart';
import 'package:locked_in/features/create_lock/presentation/widgets/selectable_app_tile.dart';
import 'package:locked_in/features/create_lock/presentation/screens/lock_duration_screen.dart';

class CreateLockScreen extends ConsumerWidget {
  const CreateLockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createLockProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CreateLockAppBar(),
      body: _buildBody(context, ref, state),
      bottomNavigationBar: _ContinueButton(
        enabled: state.hasSelection,
        onTap: () {
          ref.read(createLockProvider.notifier).resetStatus();
          final selectedApps = state.allApps
              .where((a) => state.selectedAppIds.contains(a.id))
              .toList();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LockDurationScreen(selectedApps: selectedApps),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CreateLockState state,
  ) {
    if (state.status == CreateLockStatus.loading ||
        (state.status == CreateLockStatus.initial && state.allApps.isEmpty)) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.status == CreateLockStatus.failure) {
      return Center(
        child: Text(
          state.errorMessage ?? 'Something went wrong',
          style: const TextStyle(color: AppColors.gray),
        ),
      );
    }

    return Column(
      children: [
        AppSearchBar(
          onChanged: (q) => ref.read(createLockProvider.notifier).search(q),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.filteredApps.length,
            itemBuilder: (_, i) {
              final app = state.filteredApps[i];
              return SelectableAppTile(
                app: app,
                isSelected: state.selectedAppIds.contains(app.id),
                onTap: () =>
                    ref.read(createLockProvider.notifier).toggleApp(app),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Bottom Continue Button ──────────────────────────────────────────────────

class _ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _ContinueButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.4),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Continue',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
