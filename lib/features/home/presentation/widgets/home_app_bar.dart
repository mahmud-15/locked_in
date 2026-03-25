import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/core/constants/app_strings.dart';
import 'package:locked_in/core/router/route_names.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _TitleSection(dateLabel: today),
          const Spacer(),
          GestureDetector(
            onTap: () => context.goNamed(RouteNames.subscription),
            child: _SubscriptionsPill(),
          ),
          const SizedBox(width: 10),
          _NotificationBell(),
        ],
      ),
    );
  }
}

class _TitleSection extends StatelessWidget {
  final String dateLabel;
  const _TitleSection({required this.dateLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            SizedBox(width: 6),
            Text('🔒', style: TextStyle(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          dateLabel,
          style: const TextStyle(fontSize: 12, color: AppColors.gray),
        ),
      ],
    );
  }
}

class _SubscriptionsPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            size: 14,
            color: AppColors.primary,
          ),
          SizedBox(width: 4),
          Text(
            AppStrings.subscriptions,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),

      child: const Icon(
        Icons.notifications_outlined,
        size: 25,
        color: AppColors.black,
      ),
    );
  }
}
