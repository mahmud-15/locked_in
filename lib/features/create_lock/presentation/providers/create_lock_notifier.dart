import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/create_lock/data/datasources/create_lock_local_data_source.dart';
import 'package:locked_in/features/create_lock/data/repositories/create_lock_repository_impl.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';
import 'package:locked_in/features/create_lock/domain/usecases/create_lock_usecase.dart';
import 'package:locked_in/features/create_lock/domain/usecases/get_available_apps_usecase.dart';
import 'package:locked_in/features/create_lock/presentation/providers/create_lock_state.dart';

class CreateLockNotifier extends StateNotifier<CreateLockState> {
  final GetAvailableAppsUseCase _getApps;
  final CreateLockUseCase _createLock;

  CreateLockNotifier({
    required GetAvailableAppsUseCase getApps,
    required CreateLockUseCase createLock,
  }) : _getApps = getApps,
       _createLock = createLock,
       super(const CreateLockState()) {
    loadApps();
  }

  Future<void> loadApps() async {
    state = state.copyWith(status: CreateLockStatus.loading);
    final result = await _getApps();
    result.fold(
      (f) => state = state.copyWith(
        status: CreateLockStatus.failure,
        errorMessage: f.message,
      ),
      (apps) => state = state.copyWith(
        status: CreateLockStatus.success,
        allApps: apps,
        filteredApps: apps,
      ),
    );
  }

  void search(String query) {
    final q = query.toLowerCase();
    final filtered = q.isEmpty
        ? state.allApps
        : state.allApps
              .where(
                (a) =>
                    a.name.toLowerCase().contains(q) ||
                    a.category.toLowerCase().contains(q),
              )
              .toList();
    state = state.copyWith(searchQuery: query, filteredApps: filtered);
  }

  void toggleApp(AppToLockEntity app) {
    final updated = Set<String>.from(state.selectedAppIds);
    if (updated.contains(app.id)) {
      updated.remove(app.id);
    } else {
      updated.add(app.id);
    }
    state = state.copyWith(selectedAppIds: updated);
  }

  void setDuration(String appId, int durationIndex) {
    final updatedDurations = Map<String, int>.from(state.selectedAppDurations);
    updatedDurations[appId] = durationIndex;
    state = state.copyWith(selectedAppDurations: updatedDurations);
  }

  void resetStatus() {
    state = state.copyWith(status: CreateLockStatus.initial);
  }

  Future<void> confirmLock() async {
    if (!state.hasSelection) return;
    state = state.copyWith(status: CreateLockStatus.submitting);

    // Filter durations to only include selected apps
    final selectedDurations = <String, int>{};
    for (var id in state.selectedAppIds) {
      selectedDurations[id] = state.selectedAppDurations[id] ?? 0;
    }

    final result = await _createLock(selectedDurations);
    result.fold(
      (f) => state = state.copyWith(
        status: CreateLockStatus.failure,
        errorMessage: f.message,
      ),
      (_) => state = state.copyWith(
        status: CreateLockStatus.success,
        selectedAppIds: {},
        selectedAppDurations: {},
      ),
    );
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────

final _createLockDataSourceProvider = Provider<CreateLockLocalDataSource>(
  (_) => CreateLockLocalDataSourceImpl(),
);

final _createLockRepositoryProvider = Provider(
  (ref) => CreateLockRepositoryImpl(ref.read(_createLockDataSourceProvider)),
);

final _getAvailableAppsProvider = Provider(
  (ref) => GetAvailableAppsUseCase(ref.read(_createLockRepositoryProvider)),
);

final _createLockUseCaseProvider = Provider(
  (ref) => CreateLockUseCase(ref.read(_createLockRepositoryProvider)),
);

final createLockProvider =
    StateNotifierProvider<CreateLockNotifier, CreateLockState>(
      (ref) => CreateLockNotifier(
        getApps: ref.read(_getAvailableAppsProvider),
        createLock: ref.read(_createLockUseCaseProvider),
      ),
    );
