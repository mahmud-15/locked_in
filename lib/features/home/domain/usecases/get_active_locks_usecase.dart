import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';
import 'package:locked_in/features/home/domain/repositories/home_repository.dart';

class GetActiveLocksUseCase {
  final HomeRepository _repository;

  const GetActiveLocksUseCase(this._repository);

  Future<Either<Failure, List<LockedAppEntity>>> call() {
    return _repository.getActiveLocks();
  }
}
