import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:locked_in/core/services/app_monitoring_service.dart';
import 'package:locked_in/core/utils/lock_time_calculator.dart';

class UsageStat {
  final String packageName;
  final String appName;
  final Duration duration;
  final int opens;
  final double percentage;
  final Uint8List? appIcon;

  UsageStat({
    required this.packageName,
    required this.appName,
    required this.duration,
    required this.opens,
    this.percentage = 0,
    this.appIcon,
  });

  UsageStat copyWith({double? percentage}) {
    return UsageStat(
      packageName: packageName,
      appName: appName,
      duration: duration,
      opens: opens,
      percentage: percentage ?? this.percentage,
      appIcon: appIcon,
    );
  }
}

class DayUsage {
  final DateTime date;
  final Duration totalUsage;

  DayUsage(this.date, this.totalUsage);
}

class UsageStatsState {
  final List<UsageStat> stats;
  final bool isLoading;
  final Duration totalUsage;
  final Duration yesterdayTotalUsage;
  final List<DayUsage> weeklyStats;

  UsageStatsState({
    required this.stats,
    this.isLoading = false,
    this.totalUsage = Duration.zero,
    this.yesterdayTotalUsage = Duration.zero,
    this.weeklyStats = const [],
  });
}

class UsageStatsNotifier extends StateNotifier<UsageStatsState> {
  final AppMonitoringService _monitoringService = AppMonitoringService();

  UsageStatsNotifier() : super(UsageStatsState(stats: [])) {
    loadStats();
  }

  Future<void> loadStats() async {
    state = UsageStatsState(
      stats: state.stats,
      isLoading: true,
      totalUsage: state.totalUsage,
      yesterdayTotalUsage: state.yesterdayTotalUsage,
      weeklyStats: state.weeklyStats,
    );

    // Fetch Today's stats
    final now = DateTime.now();
    final todayStr = DateFormat('yyyyMMdd').format(now);
    final rawToday = await _monitoringService.getAppUsageStats(
      date: todayStr,
    );

    List<UsageStat> todayStats = rawToday
        .map(
          (s) => UsageStat(
            packageName: s['packageName'] as String,
            appName: s['appName'] as String,
            duration: Duration(milliseconds: s['usageMs'] as int),
            opens: (s['opens'] as int),
            appIcon: s['appIcon'] as Uint8List?,
          ),
        )
        .toList();

    todayStats.sort((a, b) => b.duration.compareTo(a.duration));
    final todayTotalMs = todayStats.fold<int>(
      0,
      (sum, item) => sum + item.duration.inMilliseconds,
    );

    // Percentage Calculation for today
    if (todayTotalMs > 0) {
      todayStats = todayStats
          .map(
            (s) => s.copyWith(
              percentage: (s.duration.inMilliseconds / todayTotalMs) * 100,
            ),
          )
          .toList();
    }

    // Fetch real clock focus/locked time using LockTimeCalculator
    final sessions = await LockTimeCalculator.getSessions();
    final todayFocusMins = LockTimeCalculator.calculateLockedMinutesForDate(
      sessions: sessions,
      date: now,
      now: now,
    );
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayFocusMins = LockTimeCalculator.calculateLockedMinutesForDate(
      sessions: sessions,
      date: yesterday,
      now: now,
    );

    // Fetch Last 7 Days for trend using real clock focus time
    List<DayUsage> weekTrend = [];
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dayMins = LockTimeCalculator.calculateLockedMinutesForDate(
        sessions: sessions,
        date: date,
        now: now,
      );
      weekTrend.add(DayUsage(date, Duration(seconds: (dayMins * 60).round())));
    }

    state = UsageStatsState(
      stats: todayStats,
      isLoading: false,
      totalUsage: Duration(seconds: (todayFocusMins * 60).round()),
      yesterdayTotalUsage: Duration(seconds: (yesterdayFocusMins * 60).round()),
      weeklyStats: weekTrend.reversed.toList(),
    );
  }
}

final usageStatsProvider =
    StateNotifierProvider<UsageStatsNotifier, UsageStatsState>((ref) {
      return UsageStatsNotifier();
    });
