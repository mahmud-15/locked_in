import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';
import 'package:locked_in/features/create_lock/domain/repositories/create_lock_repository.dart';

class GetAvailableAppsUseCase {
  final CreateLockRepository _repository;

  const GetAvailableAppsUseCase(this._repository);

  Future<Either<Failure, List<AppToLockEntity>>> call() {
    return _repository.getAvailableApps();
  }
}
