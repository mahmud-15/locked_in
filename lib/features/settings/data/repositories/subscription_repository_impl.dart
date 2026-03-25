import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/settings/data/datasources/subscription_remote_data_source.dart';
import 'package:locked_in/features/settings/domain/entities/subscription_plan_entity.dart';
import 'package:locked_in/features/settings/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource _remoteDataSource;

  const SubscriptionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<SubscriptionPlanEntity>>> getPlans() async {
    try {
      final result = await _remoteDataSource.getPlans();
      return right(result);
    } catch (_) {
      return left(ServerFailure('Failed to fetch subscription plans'));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToPlan(String planId) async {
    try {
      await _remoteDataSource.subscribeToPlan(planId);
      return right(null);
    } catch (_) {
      return left(ServerFailure('Failed to subscribe to plan'));
    }
  }
}
