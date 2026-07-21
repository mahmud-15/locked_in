import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/settings/data/datasources/subscription_remote_data_source.dart';
import 'package:locked_in/features/settings/data/repositories/subscription_repository_impl.dart';
import 'package:locked_in/features/settings/domain/usecases/get_subscription_plans_usecase.dart';
import 'package:locked_in/features/settings/domain/usecases/subscribe_usecase.dart';
import 'package:locked_in/features/settings/presentation/providers/subscription_state.dart';
import 'package:locked_in/features/auth/presentation/providers/auth_provider.dart';

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final GetSubscriptionPlansUseCase _getPlans;
  final SubscribeUseCase _subscribe;
  final Ref _ref;

  SubscriptionNotifier({
    required GetSubscriptionPlansUseCase getPlans,
    required SubscribeUseCase subscribeUseCase,
    required Ref ref,
  }) : _getPlans = getPlans,
       _subscribe = subscribeUseCase,
       _ref = ref,
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

  Future<String?> initiateSubscription(String planId) async {
    state = state.copyWith(isSubscribing: true, errorMessage: null);

    final result = await _subscribe(planId);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSubscribing: false,
          errorMessage: failure.message,
        );
        return null;
      },
      (checkoutUrl) {
        state = state.copyWith(isSubscribing: false);
        return checkoutUrl;
      },
    );
  }

  // To be called after successful webview payment
  void onPaymentSuccess() {
    _ref.read(authProvider.notifier).updateSubscriptionStatus(true);
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

final _subscribeUseCaseProvider = Provider(
  (ref) => SubscribeUseCase(ref.read(_subscriptionRepositoryProvider)),
);

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
      (ref) => SubscriptionNotifier(
        getPlans: ref.read(_getPlansUseCaseProvider),
        subscribeUseCase: ref.read(_subscribeUseCaseProvider),
        ref: ref,
      ),
    );
