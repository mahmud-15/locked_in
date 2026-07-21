import 'package:hive_flutter/hive_flutter.dart';
import 'package:locked_in/core/network/local_storage.dart';

class Interval {
  final DateTime start;
  final DateTime end;

  Interval(this.start, this.end);
}

class LockTimeCalculator {
  static double calculateLockedMinutesForDate({
    required List<Map<String, dynamic>> sessions,
    required DateTime date,
    required DateTime now,
  }) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    // If the date is in the future relative to now, return 0
    if (startOfDay.isAfter(now)) {
      return 0.0;
    }

    // The upper limit for elapsed time is the end of the day, or 'now' if the date is today
    final isToday = startOfDay.year == now.year &&
        startOfDay.month == now.month &&
        startOfDay.day == now.day;
    final upperLimit = isToday ? now : endOfDay;

    List<Interval> clamped = [];
    for (var session in sessions) {
      if (session['userId'] != LocalStorage.userId) continue;
      final startTimeStr = session['startTime'] as String?;
      final endTimeStr = session['endTime'] as String?;
      if (startTimeStr == null || endTimeStr == null) continue;

      final startTime = DateTime.parse(startTimeStr);
      final endTime = DateTime.parse(endTimeStr);

      if (endTime.isBefore(startOfDay) || startTime.isAfter(upperLimit)) {
        continue;
      }
      final start = startTime.isBefore(startOfDay) ? startOfDay : startTime;
      final end = endTime.isAfter(upperLimit) ? upperLimit : endTime;
      if (end.isAfter(start)) {
        clamped.add(Interval(start, end));
      }
    }

    if (clamped.isEmpty) return 0.0;

    // Sort by start time
    clamped.sort((a, b) => a.start.compareTo(b.start));

    // Merge intervals
    List<Interval> merged = [];
    var current = clamped.first;
    for (int i = 1; i < clamped.length; i++) {
      var next = clamped[i];
      if (next.start.isBefore(current.end) ||
          next.start.isAtSameMomentAs(current.end)) {
        if (next.end.isAfter(current.end)) {
          current = Interval(current.start, next.end);
        }
      } else {
        merged.add(current);
        current = next;
      }
    }
    merged.add(current);

    // Sum durations
    double totalMinutes = 0;
    for (var interval in merged) {
      totalMinutes += interval.end.difference(interval.start).inSeconds / 60.0;
    }
    return totalMinutes;
  }

  static Future<List<Map<String, dynamic>>> getSessions() async {
    final box = await Hive.openBox('lock_sessions');
    final List<Map<String, dynamic>> sessions = [];
    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        sessions.add(Map<String, dynamic>.from(data));
      }
    }
    return sessions;
  }
}
