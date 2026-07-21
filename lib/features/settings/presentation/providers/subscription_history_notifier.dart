import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/settings/data/datasources/subscription_remote_data_source.dart';
import 'package:locked_in/features/settings/data/repositories/subscription_repository_impl.dart';
import 'package:locked_in/features/settings/domain/usecases/get_subscription_history_usecase.dart';
import 'package:locked_in/features/settings/domain/entities/user_subscription_entity.dart';

enum HistoryStatus { initial, loading, success, failure }

class SubscriptionHistoryState {
  final HistoryStatus status;
  final List<UserSubscriptionEntity> history;
  final String? errorMessage;

  const SubscriptionHistoryState({
    this.status = HistoryStatus.initial,
    this.history = const [],
    this.errorMessage,
  });

  SubscriptionHistoryState copyWith({
    HistoryStatus? status,
    List<UserSubscriptionEntity>? history,
    String? errorMessage,
  }) {
    return SubscriptionHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SubscriptionHistoryNotifier
    extends StateNotifier<SubscriptionHistoryState> {
  final GetSubscriptionHistoryUseCase _getHistory;

  SubscriptionHistoryNotifier(this._getHistory)
    : super(const SubscriptionHistoryState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(status: HistoryStatus.loading);
    final result = await _getHistory();
    result.fold(
      (failure) => state = state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: failure.message,
      ),
      (history) => state = state.copyWith(
        status: HistoryStatus.success,
        history: history,
      ),
    );
  }
}

// Providers
final _historyDataSourceProvider = Provider<SubscriptionRemoteDataSource>(
  (_) => SubscriptionRemoteDataSourceImpl(),
);

final _historyRepositoryProvider = Provider(
  (ref) => SubscriptionRepositoryImpl(ref.read(_historyDataSourceProvider)),
);

final _getHistoryUseCaseProvider = Provider(
  (ref) => GetSubscriptionHistoryUseCase(ref.read(_historyRepositoryProvider)),
);

final subscriptionHistoryProvider =
    StateNotifierProvider<
      SubscriptionHistoryNotifier,
      SubscriptionHistoryState
    >(
      (ref) =>
          SubscriptionHistoryNotifier(ref.read(_getHistoryUseCaseProvider)),
    );
