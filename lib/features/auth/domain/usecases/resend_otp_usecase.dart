import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/auth/domain/repositories/auth_repository.dart';

@injectable
class ResendOtpUseCase {
  final AuthRepository _repository;

  ResendOtpUseCase(this._repository);

  Future<Either<Failure, void>> call(String email) async {
    return await _repository.resendOtp(email);
  }
}
