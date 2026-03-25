import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/core/services/app_monitoring_service.dart';
import 'package:locked_in/features/home/data/datasources/home_local_data_source.dart';
import 'package:locked_in/features/home/data/repositories/home_repository_impl.dart';
import 'package:locked_in/features/home/domain/usecases/get_active_locks_usecase.dart';
import 'package:locked_in/features/home/domain/usecases/get_home_stats_usecase.dart';
import 'package:locked_in/features/home/presentation/providers/home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final GetActiveLocksUseCase _getActiveLocks;
  final GetHomeStatsUseCase _getHomeStats;
  final AppMonitoringService _monitoringService = AppMonitoringService();

  HomeNotifier({
    required GetActiveLocksUseCase getActiveLocks,
    required GetHomeStatsUseCase getHomeStats,
  }) : _getActiveLocks = getActiveLocks,
       _getHomeStats = getHomeStats,
       super(const HomeState()) {
    loadData();
    checkAccessibilityStatus();
  }

  Future<void> checkAccessibilityStatus() async {
    final isEnabled = await _monitoringService.isAccessibilityEnabled();
    state = state.copyWith(isAccessibilityEnabled: isEnabled);
  }

  Future<void> openAccessibilitySettings() async {
    await _monitoringService.openAccessibilitySettings();
  }

  Future<void> loadData() async {
    state = state.copyWith(status: HomeStatus.loading);

    final locksResult = await _getActiveLocks();
    final statsResult = await _getHomeStats();

    locksResult.fold(
      (failure) => state = state.copyWith(
        status: HomeStatus.failure,
        errorMessage: failure.message,
      ),
      (locks) => state = state.copyWith(activeLocks: locks),
    );

    statsResult.fold(
      (failure) => state = state.copyWith(
        status: HomeStatus.failure,
        errorMessage: failure.message,
      ),
      (stats) =>
          state = state.copyWith(status: HomeStatus.success, stats: stats),
    );
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────

final _homeLocalDataSourceProvider = Provider<HomeLocalDataSource>(
  (_) => HomeLocalDataSourceImpl(),
);

final _homeRepositoryProvider = Provider(
  (ref) => HomeRepositoryImpl(ref.read(_homeLocalDataSourceProvider)),
);

final _getActiveLocksProvider = Provider(
  (ref) => GetActiveLocksUseCase(ref.read(_homeRepositoryProvider)),
);

final _getHomeStatsProvider = Provider(
  (ref) => GetHomeStatsUseCase(ref.read(_homeRepositoryProvider)),
);

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(
    getActiveLocks: ref.read(_getActiveLocksProvider),
    getHomeStats: ref.read(_getHomeStatsProvider),
  ),
);
