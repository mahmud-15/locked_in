import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/settings/domain/entities/subscription_plan_entity.dart';
import 'package:locked_in/features/settings/domain/repositories/subscription_repository.dart';

class GetSubscriptionPlansUseCase {
  final SubscriptionRepository _repository;

  const GetSubscriptionPlansUseCase(this._repository);

  Future<Either<Failure, List<SubscriptionPlanEntity>>> call() {
    return _repository.getPlans();
  }
}
