import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/home/data/datasources/home_local_data_source.dart';
import 'package:locked_in/features/home/domain/entities/home_stats_entity.dart';
import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';
import 'package:locked_in/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource _localDataSource;

  const HomeRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<LockedAppEntity>>> getActiveLocks() async {
    try {
      final result = await _localDataSource.getActiveLocks();
      return right(result);
    } catch (e) {
      return left(CacheFailure('Failed to fetch active locks'));
    }
  }

  @override
  Future<Either<Failure, HomeStatsEntity>> getHomeStats() async {
    try {
      final result = await _localDataSource.getHomeStats();
      return right(result);
    } catch (e) {
      return left(CacheFailure('Failed to fetch home stats'));
    }
  }
}
