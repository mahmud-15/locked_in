import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/home/domain/repositories/home_repository.dart';

class UnlockAppUseCase {
  final HomeRepository _repository;

  UnlockAppUseCase(this._repository);

  Future<Either<Failure, void>> call(String appId) {
    return _repository.unlockApp(appId);
  }
}
