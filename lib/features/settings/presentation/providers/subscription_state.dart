import 'package:locked_in/features/settings/domain/entities/subscription_plan_entity.dart';

enum SubscriptionStatus { initial, loading, success, failure }

class SubscriptionState {
  final SubscriptionStatus status;
  final List<SubscriptionPlanEntity> plans;
  final String? activePlanId;
  final bool isSubscribing;
  final String? errorMessage;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.plans = const [],
    this.activePlanId,
    this.isSubscribing = false,
    this.errorMessage,
  });

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    List<SubscriptionPlanEntity>? plans,
    String? activePlanId,
    bool? isSubscribing,
    String? errorMessage,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      activePlanId: activePlanId ?? this.activePlanId,
      isSubscribing: isSubscribing ?? this.isSubscribing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
