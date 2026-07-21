import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/emergency_unlock/domain/repositories/emergency_unlock_repository.dart';

@injectable
class VerifyOtpUseCase {
  final EmergencyUnlockRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<Either<Failure, String>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(
      appName: params.appName,
      contactId: params.contactId,
      otp: params.otp,
    );
  }
}

class VerifyOtpParams {
  final String appName;
  final String contactId;
  final int otp;

  VerifyOtpParams({
    required this.appName,
    required this.contactId,
    required this.otp,
  });
}
