import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';
import 'package:locked_in/features/settings/domain/entities/user_subscription_entity.dart';
import 'package:locked_in/features/settings/presentation/providers/subscription_history_notifier.dart';

class SubscriptionHistoryScreen extends ConsumerWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Subscription History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    SubscriptionHistoryState state,
  ) {
    if (state.status == HistoryStatus.loading ||
        state.status == HistoryStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.status == HistoryStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.errorMessage ?? 'Failed to load history'),
            TextButton(
              onPressed: () =>
                  ref.read(subscriptionHistoryProvider.notifier).loadHistory(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 80.w,
              color: AppColors.gray.withOpacity(0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              'No history found',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: state.history.length,
      itemBuilder: (context, index) {
        final item = state.history[index];
        return _SubscriptionHistoryCard(item: item);
      },
    );
  }
}

class _SubscriptionHistoryCard extends StatelessWidget {
  final UserSubscriptionEntity item;

  const _SubscriptionHistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isActive = item.status?.toLowerCase() == 'active';
    final statusColor = isActive ? Colors.green : Colors.grey;
    final startDate = item.startDate != null
        ? DateTime.parse(item.startDate!)
        : null;
    final endDate = item.endDate != null ? DateTime.parse(item.endDate!) : null;
    final formatter = DateFormat('MMM dd, yyyy');

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name ?? 'Subscription',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  item.status?.toUpperCase() ?? 'UNKNOWN',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                '\$${item.price?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: AppColors.gray,
              ),
              SizedBox(width: 4.w),
              Text(
                startDate != null ? formatter.format(startDate) : '---',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.gray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: const Text(
                  'to',
                  style: TextStyle(color: AppColors.gray, fontSize: 10),
                ),
              ),
              Text(
                endDate != null ? formatter.format(endDate) : '---',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.gray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
