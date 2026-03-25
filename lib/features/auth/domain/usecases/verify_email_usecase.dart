import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';
import 'package:locked_in/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailParams {
  final String email;
  final String oneTimeCode;

  VerifyEmailParams({required this.email, required this.oneTimeCode});
}

@injectable
class VerifyEmailUseCase {
  final AuthRepository _repository;

  VerifyEmailUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(VerifyEmailParams params) async {
    return await _repository.verifyEmail(params.email, params.oneTimeCode);
  }
}
