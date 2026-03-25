import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';

enum CreateLockStatus { initial, loading, success, submitting, failure }

class CreateLockState {
  final CreateLockStatus status;
  final List<AppToLockEntity> allApps;
  final List<AppToLockEntity> filteredApps;
  final Set<String> selectedAppIds;
  final Map<String, int> selectedAppDurations;
  final String searchQuery;
  final String? errorMessage;

  const CreateLockState({
    this.status = CreateLockStatus.initial,
    this.allApps = const [],
    this.filteredApps = const [],
    this.selectedAppIds = const {},
    this.selectedAppDurations = const {},
    this.searchQuery = '',
    this.errorMessage,
  });

  bool get hasSelection => selectedAppIds.isNotEmpty;

  CreateLockState copyWith({
    CreateLockStatus? status,
    List<AppToLockEntity>? allApps,
    List<AppToLockEntity>? filteredApps,
    Set<String>? selectedAppIds,
    Map<String, int>? selectedAppDurations,
    String? searchQuery,
    String? errorMessage,
  }) {
    return CreateLockState(
      status: status ?? this.status,
      allApps: allApps ?? this.allApps,
      filteredApps: filteredApps ?? this.filteredApps,
      selectedAppIds: selectedAppIds ?? this.selectedAppIds,
      selectedAppDurations: selectedAppDurations ?? this.selectedAppDurations,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
