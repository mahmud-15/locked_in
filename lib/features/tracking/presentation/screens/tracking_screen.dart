import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:locked_in/core/constants/app_colors.dart';
import 'package:locked_in/features/tracking/presentation/providers/usage_stats_provider.dart';
import 'package:locked_in/shared/widgets/common_text.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final usageState = ref.watch(usageStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const CommonText(
          'Reports',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(usageStatsProvider.notifier).loadStats(),
            icon: const Icon(Icons.refresh, color: AppColors.black),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: usageState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(usageStatsProvider.notifier).loadStats(),
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTotalUsageHeader(
                      usageState.totalUsage,
                      usageState.yesterdayTotalUsage,
                    ),
                    SizedBox(height: 24.h),
                    if (usageState.weeklyStats.isNotEmpty) ...[
                      _buildTrendCard(usageState.weeklyStats),
                      SizedBox(height: 24.h),
                    ],
                    if (usageState.stats.isNotEmpty) ...[
                      _buildChartCard(usageState.stats.take(5).toList()),
                      SizedBox(height: 32.h),
                      const CommonText(
                        'Most Used Apps',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      SizedBox(height: 16.h),
                      ...usageState.stats.map(
                        (stat) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildAppUsageCard(stat),
                        ),
                      ),
                    ] else
                      _buildEmptyStatsMessage(),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyStatsMessage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          children: [
            Icon(Icons.auto_graph_rounded, size: 64.w, color: Colors.grey[300]),
            SizedBox(height: 16.h),
            const CommonText(
              'No app usage recorded today',
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalUsageHeader(Duration total, Duration yesterday) {
    final hours = total.inHours;
    final minutes = total.inMinutes.remainder(60);

    final diffSeconds = yesterday.inSeconds - total.inSeconds;
    final isImprovement = diffSeconds > 0;
    final absDiffMinutes = (diffSeconds.abs() / 60).round();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D3142), Color(0xFF4F5D75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D3142).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                'Today\'s Focus',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
              if (yesterday != Duration.zero)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isImprovement
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isImprovement
                          ? Colors.greenAccent.withOpacity(0.5)
                          : Colors.orangeAccent.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isImprovement ? Icons.trending_up : Icons.trending_down,
                        color: isImprovement
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                        size: 14,
                      ),
                      SizedBox(width: 4.w),
                      CommonText(
                        isImprovement ? 'Progress' : 'Alert',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isImprovement
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CommonText(
                hours > 0 ? '$hours' : '0',
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              CommonText(
                'h ',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.7),
              ),
              CommonText(
                '$minutes',
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              CommonText(
                'm',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
          if (yesterday != Duration.zero) ...[
            SizedBox(height: 16.h),
            CommonText(
              isImprovement
                  ? 'Great! You\'ve used $absDiffMinutes mins LESS than yesterday.'
                  : 'Heads up! You\'ve used $absDiffMinutes mins MORE than yesterday.',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isImprovement ? Colors.greenAccent : Colors.orangeAccent,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendCard(List<DayUsage> week) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonText(
            'Weekly Statistics',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 120.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: week.map((day) {
                final maxMs = week.fold<int>(
                  1,
                  (max, d) => d.totalUsage.inMilliseconds > max
                      ? d.totalUsage.inMilliseconds
                      : max,
                );
                final ratio = day.totalUsage.inMilliseconds / maxMs;
                final barHeight = (ratio * 80.h).clamp(4.0, 80.h);
                final isToday = day.date.day == DateTime.now().day;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24.w,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: isToday
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    CommonText(
                      DateFormat('E').format(day.date)[0],
                      fontSize: 11,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? AppColors.black : AppColors.gray,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(List<UsageStat> topApps) {
    return Container(
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
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CommonText(
                'Category Analysis',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              const CommonText(
                'Today',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.gray,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 160.h,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double availableHeight = constraints.maxHeight - 40.h;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: topApps.map((stat) {
                    return _buildBar(
                      maxHeight: availableHeight,
                      percentage: stat.percentage / 100,
                      color: AppColors.primary.withOpacity(
                        (1.0 - (topApps.indexOf(stat) * 0.15)).clamp(0.4, 1.0),
                      ),
                      name: stat.appName,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar({
    required double maxHeight,
    required double percentage,
    required Color color,
    required String name,
  }) {
    final int labelValue = (percentage * 100).toInt();
    final double barHeight = (maxHeight * percentage).clamp(20.h, maxHeight);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 36.w,
            height: barHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$labelValue%',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: 48.w,
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppUsageCard(UsageStat stat) {
    final minutes = stat.duration.inMinutes;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAppIcon(stat.appName, stat.appIcon),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  stat.appName,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                SizedBox(height: 4.h),
                CommonText(
                  '$minutes mins • ${stat.opens} Opens',
                  fontSize: 12,
                  color: AppColors.gray,
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 44.w,
                height: 44.w,
                child: CircularProgressIndicator(
                  value: (stat.percentage / 100).clamp(0.05, 1.0),
                  backgroundColor: const Color(0xFFF1F5F9),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  strokeWidth: 3.5,
                ),
              ),
              CommonText(
                '${stat.percentage.toInt()}%',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(String name, [Uint8List? icon]) {
    if (icon != null) {
      return Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.r)),
        clipBehavior: Clip.antiAlias,
        child: Image.memory(
          icon,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackIcon(name),
        ),
      );
    }
    return _buildFallbackIcon(name);
  }

  Widget _buildFallbackIcon(String name) {
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFFEC4899),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
      const Color(0xFF3B82F6),
    ];
    final bgColor = colors[name.codeUnitAt(0) % colors.length];

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
