import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/create_lock/data/datasources/create_lock_local_data_source.dart';
import 'package:locked_in/features/create_lock/domain/entities/app_to_lock_entity.dart';
import 'package:locked_in/features/create_lock/domain/repositories/create_lock_repository.dart';

class CreateLockRepositoryImpl implements CreateLockRepository {
  final CreateLockLocalDataSource _localDataSource;

  const CreateLockRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<AppToLockEntity>>> getAvailableApps() async {
    try {
      final result = await _localDataSource.getAvailableApps();
      return right(result);
    } catch (_) {
      return left(CacheFailure('Failed to load available apps'));
    }
  }

  @override
  Future<Either<Failure, void>> createLock(
    Map<String, int> appDurations,
  ) async {
    try {
      await _localDataSource.createLock(appDurations);
      return right(null);
    } catch (_) {
      return left(CacheFailure('Failed to create lock'));
    }
  }
}
