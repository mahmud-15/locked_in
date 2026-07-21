import 'package:locked_in/features/auth/data/models/user_model.dart';
import 'package:locked_in/features/settings/data/models/subscription_plan_model.dart';
import 'package:locked_in/features/settings/data/models/user_subscription_model.dart';
import 'package:locked_in/core/constants/api_endpoints.dart';
import 'package:locked_in/core/network/api_service.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionPlanModel>> getPlans();
  Future<String> subscribeToPlan(String planId);
  Future<List<UserSubscriptionModel>> getSubscriptionHistory();
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  @override
  Future<List<SubscriptionPlanModel>> getPlans() async {
    final response = await ApiService.get(ApiEndpoints.plan);

    if (response.isSuccess) {
      final List data = response.data['data'] ?? [];
      return data
          .map(
            (json) =>
                SubscriptionPlanModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Future<String> subscribeToPlan(String planId) async {
    final response = await ApiService.post(
      ApiEndpoints.subscriptionStripe,
      body: {'receipt': planId},
    );

    if (response.isSuccess) {
      return response.data['data'] as String;
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Future<List<UserSubscriptionModel>> getSubscriptionHistory() async {
    final response = await ApiService.get(ApiEndpoints.subscriptionHistory);

    if (response.isSuccess) {
      final List data = response.data['data'] ?? [];
      return data
          .map(
            (json) =>
                UserSubscriptionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(response.message);
    }
  }
}
