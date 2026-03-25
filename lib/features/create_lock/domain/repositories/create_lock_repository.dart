import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';

abstract class CreateLockRepository {
  Future<Either<Failure, List<AppToLockEntity>>> getAvailableApps();
  Future<Either<Failure, void>> createLock(Map<String, int> appDurations);
}
