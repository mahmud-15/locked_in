import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/home/domain/entities/home_stats_entity.dart';
import 'package:locked_in/features/home/domain/entities/locked_app_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<LockedAppEntity>>> getActiveLocks();
  Future<Either<Failure, HomeStatsEntity>> getHomeStats();
}
