import 'package:hive_flutter/hive_flutter.dart';
import 'package:locked_in/core/services/app_monitoring_service.dart';
import 'package:locked_in/features/create_lock/data/models/app_to_lock_model.dart';
import 'package:locked_in/features/home/data/models/locked_app_model.dart';
import 'package:locked_in/core/network/local_storage.dart';

abstract class CreateLockLocalDataSource {
  Future<List<AppToLockModel>> getAvailableApps();
  Future<void> createLock(Map<String, int> appDurations);
}

class CreateLockLocalDataSourceImpl implements CreateLockLocalDataSource {
  final AppMonitoringService _monitoringService = AppMonitoringService();

  @override
  Future<List<AppToLockModel>> getAvailableApps() async {
    final apps = await _monitoringService.getInstalledApps();

    return apps
        .where((app) => app['packageName'] != 'com.lockedinlimited.locked_in')
        .map(
          (app) => AppToLockModel(
            id: app['packageName'] ?? '',
            name: app['appName'] ?? '',
            category: 'Installed App',
            iconKey: app['packageName'] ?? '',
            iconBytes: app['appIcon'],
          ),
        )
        .toList();
  }

  @override
  Future<void> createLock(Map<String, int> appDurations) async {
    final box = await Hive.openBox('locked_apps_data');
    final apps = await getAvailableApps();

    final now = DateTime.now();
    for (var entry in appDurations.entries) {
      final appId = entry.key;
      final durationInMinutes = entry.value;

      final lockUntil = now.add(Duration(minutes: durationInMinutes));

      final appInfo = apps.firstWhere((a) => a.id == appId);

      final lockedModel = LockedAppModel(
        id: appInfo.id,
        name: appInfo.name,
        category: appInfo.category,
        lockedDuration: _formatDuration(durationInMinutes),
        iconKey: appInfo.iconKey,
        lockUntil: lockUntil,
        iconBytes: appInfo.iconBytes,
        userId: LocalStorage.userId, // Set user ID
      );

      await box.put(appId, lockedModel.toJson());

      // Save to lock_sessions for focus duration calculation
      final sessionId = '${appId}_${now.millisecondsSinceEpoch}';
      final sessionData = {
        'id': sessionId,
        'appId': appId,
        'appName': appInfo.name,
        'startTime': now.toIso8601String(),
        'endTime': lockUntil.toIso8601String(),
        'userId': LocalStorage.userId,
      };
      final sessionsBox = await Hive.openBox('lock_sessions');
      await sessionsBox.put(sessionId, sessionData);

      // Update native side with timestamp
      await _monitoringService.updateAppLockUntil(
        appId,
        lockUntil.millisecondsSinceEpoch,
      );
    }

    // Also update the general blocked_apps list on native side (All active locks)
    final allBlockedAppIds = box.keys.map((k) => k.toString()).toList();
    await _monitoringService.updateBlockedApps(allBlockedAppIds);
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours == 0) return '$remainingMinutes min';
    if (remainingMinutes == 0) return '$hours hour${hours > 1 ? 's' : ''}';
    return '$hours h $remainingMinutes min';
  }
}
