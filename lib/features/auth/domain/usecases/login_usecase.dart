import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';
import 'package:locked_in/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
