import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/core/constants/app_strings.dart';
import 'package:locked_in/core/router/route_names.dart';
import 'package:locked_in/features/home/presentation/providers/home_notifier.dart';
import 'package:locked_in/features/home/presentation/providers/home_state.dart';
import 'package:locked_in/features/home/presentation/widgets/app_lock_tile.dart';
import 'package:locked_in/features/home/presentation/widgets/create_lock_card.dart';
import 'package:locked_in/features/home/presentation/widgets/home_app_bar.dart';
import 'package:locked_in/features/home/presentation/widgets/locked_time_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(homeProvider.notifier).checkAccessibilityStatus();
      ref.read(homeProvider.notifier).loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: _buildBody(context, state, ref)),
    );
  }

  void _showAccessibilityDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFFE5A4E)),
            SizedBox(width: 8),
            Text(
              'Permission Required',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'To block apps and stay focused, you must enable the Accessibility Service for Locked In. Please turn it on in your phone settings.',
          style: TextStyle(fontSize: 14, color: AppColors.gray, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.gray),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(homeProvider.notifier).openAccessibilitySettings();
            },
            child: const Text(
              'Go to Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state, WidgetRef ref) {
    if (state.status == HomeStatus.loading ||
        state.status == HomeStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.status == HomeStatus.failure) {
      return Center(
        child: Text(
          state.errorMessage ?? 'Something went wrong',
          style: const TextStyle(color: AppColors.gray),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: HomeAppBar()),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        if (state.stats != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LockedTimeCard(stats: state.stats!),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CreateLockCard(
              onTap: () {
                if (!state.isAccessibilityEnabled) {
                  _showAccessibilityDialog(context, ref);
                } else {
                  context.pushNamed(RouteNames.createLock);
                }
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        if (state.activeLocks.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppStrings.activeLocks,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => AppLockTile(item: state.activeLocks[i]),
                childCount: state.activeLocks.length,
              ),
            ),
          ),
        ] else
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'Your digital environment is currently open. Ready to lock in and focus?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.gray,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
