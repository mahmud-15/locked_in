import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/create_lock/domain/repositories/create_lock_repository.dart';

class CreateLockUseCase {
  final CreateLockRepository _repository;

  const CreateLockUseCase(this._repository);

  Future<Either<Failure, void>> call(Map<String, int> appDurations) {
    return _repository.createLock(appDurations);
  }
}
