import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/settings/domain/repositories/subscription_repository.dart';

class SubscribeUseCase {
  final SubscriptionRepository _repository;

  SubscribeUseCase(this._repository);

  Future<Either<Failure, String>> call(String planId) {
    return _repository.subscribeToPlan(planId);
  }
}
