import 'package:flutter/material.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/core/constants/app_strings.dart';
import 'package:locked_in/features/home/domain/entities/home_stats_entity.dart';

class LockedTimeCard extends StatelessWidget {
  final HomeStatsEntity stats;

  const LockedTimeCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFE7A4F), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LockIconBox(),
              const SizedBox(width: 12),
              Expanded(
                child: _StatsLabels(
                  title: AppStrings.todayLockedTime,
                  subtitle: stats.progressMessage,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                stats.lockedDuration,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                stats.comparisonText,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LockIconBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.lock_outline, color: Colors.white, size: 20),
    );
  }
}

class _StatsLabels extends StatelessWidget {
  final String title;
  final String subtitle;
  const _StatsLabels({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
