import 'package:locked_in/features/home/domain/entities/home_stats_entity.dart';
import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  final HomeStatus status;
  final List<LockedAppEntity> activeLocks;
  final HomeStatsEntity? stats;
  final String? errorMessage;
  final bool isAccessibilityEnabled;

  const HomeState({
    this.status = HomeStatus.initial,
    this.activeLocks = const [],
    this.stats,
    this.errorMessage,
    this.isAccessibilityEnabled = true,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<LockedAppEntity>? activeLocks,
    HomeStatsEntity? stats,
    String? errorMessage,
    bool? isAccessibilityEnabled,
  }) {
    return HomeState(
      status: status ?? this.status,
      activeLocks: activeLocks ?? this.activeLocks,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
      isAccessibilityEnabled:
          isAccessibilityEnabled ?? this.isAccessibilityEnabled,
    );
  }
}
