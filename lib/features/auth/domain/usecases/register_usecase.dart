import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';
import 'package:locked_in/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

@injectable
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await _repository.register(
      params.name,
      params.email,
      params.password,
    );
  }
}
