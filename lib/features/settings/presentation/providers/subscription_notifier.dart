import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/settings/data/datasources/subscription_remote_data_source.dart';
import 'package:locked_in/features/settings/data/repositories/subscription_repository_impl.dart';
import 'package:locked_in/features/settings/domain/usecases/get_subscription_plans_usecase.dart';
import 'package:locked_in/features/settings/presentation/providers/subscription_state.dart';

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final GetSubscriptionPlansUseCase _getPlans;

  SubscriptionNotifier({required GetSubscriptionPlansUseCase getPlans})
    : _getPlans = getPlans,
      super(const SubscriptionState()) {
    loadPlans();
  }

  Future<void> loadPlans() async {
    state = state.copyWith(status: SubscriptionStatus.loading);
    final result = await _getPlans();
    result.fold(
      (failure) => state = state.copyWith(
        status: SubscriptionStatus.failure,
        errorMessage: failure.message,
      ),
      (plans) => state = state.copyWith(
        status: SubscriptionStatus.success,
        plans: plans,
      ),
    );
  }

  void selectPlan(String planId) {
    state = state.copyWith(activePlanId: planId);
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────

final _subscriptionDataSourceProvider = Provider<SubscriptionRemoteDataSource>(
  (_) => SubscriptionRemoteDataSourceImpl(),
);

final _subscriptionRepositoryProvider = Provider(
  (ref) =>
      SubscriptionRepositoryImpl(ref.read(_subscriptionDataSourceProvider)),
);

final _getPlansUseCaseProvider = Provider(
  (ref) =>
      GetSubscriptionPlansUseCase(ref.read(_subscriptionRepositoryProvider)),
);

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
      (ref) =>
          SubscriptionNotifier(getPlans: ref.read(_getPlansUseCaseProvider)),
    );
