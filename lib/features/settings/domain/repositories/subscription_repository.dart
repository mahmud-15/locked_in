import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/settings/domain/entities/subscription_plan_entity.dart';
import 'package:locked_in/features/settings/domain/entities/user_subscription_entity.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<SubscriptionPlanEntity>>> getPlans();
  Future<Either<Failure, String>> subscribeToPlan(String planId);
  Future<Either<Failure, List<UserSubscriptionEntity>>>
  getSubscriptionHistory();
}
