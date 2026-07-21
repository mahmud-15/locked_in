import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/emergency_unlock/domain/repositories/emergency_unlock_repository.dart';

@injectable
class RequestOtpUseCase {
  final EmergencyUnlockRepository _repository;

  RequestOtpUseCase(this._repository);

  Future<Either<Failure, String>> call(RequestOtpParams params) {
    return _repository.requestOtp(
      appName: params.appName,
      contactId: params.contactId,
      message: params.message,
    );
  }
}

class RequestOtpParams {
  final String appName;
  final String contactId;
  final String message;

  RequestOtpParams({
    required this.appName,
    required this.contactId,
    required this.message,
  });
}
