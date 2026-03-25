import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/home/domain/entities/home_stats_entity.dart';
import 'package:locked_in/features/home/domain/repositories/home_repository.dart';

class GetHomeStatsUseCase {
  final HomeRepository _repository;

  const GetHomeStatsUseCase(this._repository);

  Future<Either<Failure, HomeStatsEntity>> call() {
    return _repository.getHomeStats();
  }
}
