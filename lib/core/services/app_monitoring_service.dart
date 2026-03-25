import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppMonitoringService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.locked_in/monitoring',
  );

  /// Starts the foreground service for app monitoring
  Future<bool> startService() async {
    try {
      final bool? result = await _channel.invokeMethod('startService');
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to start service: ${e.message}");
      return false;
    }
  }

  /// Stops the foreground service
  Future<bool> stopService() async {
    try {
      final bool? result = await _channel.invokeMethod('stopService');
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to stop service: ${e.message}");
      return false;
    }
  }

  /// Checks if the accessibility service is enabled
  Future<bool> isAccessibilityEnabled() async {
    try {
      final bool? result = await _channel.invokeMethod(
        'isAccessibilityEnabled',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to check accessibility status: ${e.message}");
      return false;
    }
  }

  /// Opens the accessibility settings screen
  Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } on PlatformException catch (e) {
      print("Failed to open accessibility settings: ${e.message}");
    }
  }

  /// Updates the list of apps that should be monitored/blocked
  Future<bool> updateBlockedApps(List<String> packageNames) async {
    try {
      final bool? result = await _channel.invokeMethod('updateBlockedApps', {
        'blockedApps': packageNames,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to update blocked apps: ${e.message}");
      return false;
    }
  }

  /// Updates whether the limit has been reached for a specific app
  Future<bool> updateAppLimitStatus(
    String packageName,
    bool isLimitReached,
  ) async {
    try {
      final bool? result = await _channel.invokeMethod('updateAppLimitStatus', {
        'packageName': packageName,
        'isLimitReached': isLimitReached,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to update app limit status: ${e.message}");
      return false;
    }
  }

  /// Fetches the list of installed apps from the device
  Future<List<Map<String, dynamic>>> getInstalledApps() async {
    try {
      final dynamic result = await _channel.invokeMethod('getInstalledApps');
      if (result is List) {
        return result.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } on PlatformException catch (e) {
      print("Failed to get installed apps: ${e.message}");
      return [];
    }
  }

  /// Sets a lock period for a specific app on the native side
  Future<bool> updateAppLockUntil(String packageName, int lockUntilMs) async {
    try {
      final bool? result = await _channel.invokeMethod('updateAppLockUntil', {
        'packageName': packageName,
        'lockUntil': lockUntilMs,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print("Failed to update app lock until: ${e.message}");
      return false;
    }
  }
}
