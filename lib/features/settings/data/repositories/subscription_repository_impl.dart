import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/settings/data/datasources/subscription_remote_data_source.dart';
import 'package:locked_in/features/settings/domain/entities/subscription_plan_entity.dart';
import 'package:locked_in/features/settings/domain/repositories/subscription_repository.dart';
import 'package:locked_in/features/settings/domain/entities/user_subscription_entity.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource _remoteDataSource;

  const SubscriptionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<SubscriptionPlanEntity>>> getPlans() async {
    try {
      final result = await _remoteDataSource.getPlans();
      return right(result);
    } catch (e, stacktrace) {
      print('DEBUG GET PLANS ERROR: $e');
      print(stacktrace);
      return left(ServerFailure('Failed to fetch subscription plans'));
    }
  }

  @override
  Future<Either<Failure, String>> subscribeToPlan(String planId) async {
    try {
      final url = await _remoteDataSource.subscribeToPlan(planId);
      return right(url);
    } catch (_) {
      return left(ServerFailure('Failed to initiate subscription'));
    }
  }

  @override
  Future<Either<Failure, List<UserSubscriptionEntity>>>
  getSubscriptionHistory() async {
    try {
      final result = await _remoteDataSource.getSubscriptionHistory();
      final entities = result
          .map(
            (model) => UserSubscriptionEntity(
              id: model.id,
              name: model.name,
              price: model.price,
              status: model.status,
              startDate: model.startDate,
              endDate: model.endDate,
            ),
          )
          .toList();
      return right(entities);
    } catch (_) {
      return left(ServerFailure('Failed to fetch subscription history'));
    }
  }
}
