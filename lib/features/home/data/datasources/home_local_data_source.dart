import 'package:hive_flutter/hive_flutter.dart';
import 'package:locked_in/core/services/app_monitoring_service.dart';
import 'package:locked_in/features/home/data/models/home_stats_model.dart';
import 'package:locked_in/features/home/data/models/locked_app_model.dart';

abstract class HomeLocalDataSource {
  Future<List<LockedAppModel>> getActiveLocks();
  Future<HomeStatsModel> getHomeStats();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final AppMonitoringService _monitoringService = AppMonitoringService();

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

  @override
  Future<HomeStatsModel> getHomeStats() async {
    final locks = await getActiveLocks();
    double totalHours = 0;
    for (var lock in locks) {
      final diff = lock.lockUntil.difference(DateTime.now());
      if (!diff.isNegative) {
        totalHours += diff.inMinutes / 60.0;
      }
    }

    return HomeStatsModel(
      lockedDuration: '${totalHours.toStringAsFixed(1)}h',
      progressMessage: totalHours > 0 ? 'Locked In!' : 'No Active Locks',
      comparisonText: 'Monitoring your productivity',
    );
  }
}
