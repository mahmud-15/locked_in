import 'package:hive_flutter/hive_flutter.dart';
import 'package:locked_in/core/services/app_monitoring_service.dart';
import 'package:locked_in/features/home/data/models/home_stats_model.dart';
import 'package:locked_in/features/home/data/models/locked_app_model.dart';
import 'package:locked_in/core/network/local_storage.dart';
import 'package:locked_in/core/utils/lock_time_calculator.dart';

abstract class HomeLocalDataSource {
  Future<List<LockedAppModel>> getActiveLocks();
  Future<HomeStatsModel> getHomeStats();
  Future<void> unlockApp(String appId);
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final AppMonitoringService _monitoringService = AppMonitoringService();

  @override
  Future<void> unlockApp(String appId) async {
    final box = await Hive.openBox('locked_apps_data');
    await box.delete(appId);

    // Update the lock session to be cut short in lock_sessions
    final sessionsBox = await Hive.openBox('lock_sessions');
    final now = DateTime.now();
    for (var key in sessionsBox.keys) {
      final data = sessionsBox.get(key);
      if (data != null) {
        final session = Map<String, dynamic>.from(data);
        if (session['appId'] == appId && session['userId'] == LocalStorage.userId) {
          final endTimeStr = session['endTime'] as String?;
          if (endTimeStr != null) {
            final endTime = DateTime.parse(endTimeStr);
            if (endTime.isAfter(now)) {
              session['endTime'] = now.toIso8601String();
              await sessionsBox.put(key, session);
            }
          }
        }
      }
    }

    // Sync native side to immediately unlock
    await _monitoringService.updateAppLockUntil(appId, 0);

    // Re-fetch active locks to update the blocked list on native side
    final locks = await getActiveLocks();
    final activeIds = locks.map((a) => a.id).toList();
    await _monitoringService.updateBlockedApps(activeIds);
  }

  @override
  Future<List<LockedAppModel>> getActiveLocks() async {
    final box = await Hive.openBox('locked_apps_data');
    final List<LockedAppModel> activeLocks = [];
    final now = DateTime.now();
    bool needsCleanupSync = false;

    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        final model = LockedAppModel.fromJson(Map<String, dynamic>.from(data));

        // Filter by user ID
        if (model.userId != LocalStorage.userId) {
          continue;
        }

        // Only include if not expired
        if (model.lockUntil.isAfter(now)) {
          activeLocks.add(model);
        } else {
          // Cleanup expired locks
          await box.delete(key);
          needsCleanupSync = true;
        }
      }
    }

    if (needsCleanupSync) {
      final activeIds = activeLocks.map((a) => a.id).toList();
      await _monitoringService.updateBlockedApps(activeIds);
    }

    return activeLocks;
  }

  int _parseDurationToMinutes(String durationStr) {
    try {
      final cleanStr = durationStr.trim().toLowerCase();
      
      // "30 min"
      if (cleanStr.endsWith('min') && !cleanStr.contains('h')) {
        final val = cleanStr.replaceAll('min', '').trim();
        return int.tryParse(val) ?? 30;
      }
      
      // "1 hour", "2 hours"
      if (cleanStr.contains('hour')) {
        final val = cleanStr.replaceAll(RegExp(r'hours?'), '').trim();
        return (int.tryParse(val) ?? 1) * 60;
      }
      
      // "1 h 30 min"
      if (cleanStr.contains('h') && cleanStr.contains('min')) {
        final parts = cleanStr.split('h');
        if (parts.length == 2) {
          final hours = int.tryParse(parts[0].trim()) ?? 0;
          final mins = int.tryParse(parts[1].replaceAll('min', '').trim()) ?? 0;
          return (hours * 60) + mins;
        }
      }
    } catch (_) {}
    return 30; // fallback
  }

  @override
  Future<HomeStatsModel> getHomeStats() async {
    final locks = await getActiveLocks();
    final sessions = await LockTimeCalculator.getSessions();
    final totalMins = LockTimeCalculator.calculateLockedMinutesForDate(
      sessions: sessions,
      date: DateTime.now(),
      now: DateTime.now(),
    );
    final totalHours = totalMins / 60.0;

    return HomeStatsModel(
      lockedDuration: '${totalHours.toStringAsFixed(1)}h',
      progressMessage: locks.isNotEmpty ? 'Locked In!' : 'No Active Locks',
      comparisonText: 'Monitoring your productivity',
    );
  }
}
