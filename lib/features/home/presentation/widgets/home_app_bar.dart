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
          Expanded(child: _TitleSection(dateLabel: today)),
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
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.black,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(width: 6),
            Text('🔒', style: TextStyle(fontSize: 20)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          dateLabel,
          style: const TextStyle(fontSize: 12, color: AppColors.gray),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(RouteNames.notifications),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: const Icon(
          Icons.notifications_outlined,
          size: 25,
          color: AppColors.black,
        ),
      ),
    );
  }
}
