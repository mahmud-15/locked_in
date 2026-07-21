import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';
import 'package:locked_in/features/settings/domain/repositories/profile_repository.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepository _repository;

  const GetProfileUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() async {
    return _repository.getProfile();
  }
}

@injectable
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(String name) async {
    return _repository.updateProfile(name);
  }
}
