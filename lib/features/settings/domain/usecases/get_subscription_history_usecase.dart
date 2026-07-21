import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/settings/domain/repositories/subscription_repository.dart';
import 'package:locked_in/features/settings/domain/entities/user_subscription_entity.dart';

class GetSubscriptionHistoryUseCase {
  final SubscriptionRepository _repository;

  GetSubscriptionHistoryUseCase(this._repository);

  Future<Either<Failure, List<UserSubscriptionEntity>>> call() {
    return _repository.getSubscriptionHistory();
  }
}
