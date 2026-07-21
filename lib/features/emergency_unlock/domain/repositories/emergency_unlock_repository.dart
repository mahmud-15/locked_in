import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';

abstract class EmergencyUnlockRepository {
  Future<Either<Failure, String>> requestOtp({
    required String appName,
    required String contactId,
    required String message,
  });

  Future<Either<Failure, String>> verifyOtp({
    required String appName,
    required String contactId,
    required int otp,
  });
}
