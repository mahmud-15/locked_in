import 'package:locked_in/features/settings/data/models/subscription_plan_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionPlanModel>> getPlans();
  Future<void> subscribeToPlan(String planId);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  // TODO: inject Dio and call real API
  @override
  Future<List<SubscriptionPlanModel>> getPlans() async {
    const _features = [
      'Follow to updates',
      'See all post',
      'New feature unlock',
      'See all post',
      'Follow to updates',
      'Follow to updates',
    ];

    return const [
      SubscriptionPlanModel(
        id: 'free',
        name: 'Free',
        price: '\$4.99',
        billingCycle: '/monthly',
        tagline: 'Follow along for public updates',
        features: _features,
      ),
      SubscriptionPlanModel(
        id: 'premium',
        name: 'Premium',
        price: '\$4.99',
        billingCycle: '/monthly',
        tagline: 'Follow along for public updates',
        features: _features,
        isPopular: true,
      ),
      SubscriptionPlanModel(
        id: 'diamond',
        name: 'Diamond',
        price: '\$4.99',
        billingCycle: '/monthly',
        tagline: 'Follow along for public updates',
        features: _features,
      ),
    ];
  }

  @override
  Future<void> subscribeToPlan(String planId) async {
    // TODO: POST /subscriptions/{planId}
  }
}
