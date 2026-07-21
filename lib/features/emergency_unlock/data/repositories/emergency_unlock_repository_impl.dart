import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/emergency_unlock/data/datasources/emergency_unlock_remote_data_source.dart';
import 'package:locked_in/features/emergency_unlock/domain/repositories/emergency_unlock_repository.dart';

@LazySingleton(as: EmergencyUnlockRepository)
class EmergencyUnlockRepositoryImpl implements EmergencyUnlockRepository {
  final EmergencyUnlockRemoteDataSource _remoteDataSource;

  EmergencyUnlockRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> requestOtp({
    required String appName,
    required String contactId,
    required String message,
  }) async {
    try {
      final result = await _remoteDataSource.requestOtp(
        appName: appName,
        contactId: contactId,
        message: message,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required String appName,
    required String contactId,
    required int otp,
  }) async {
    try {
      final result = await _remoteDataSource.verifyOtp(
        appName: appName,
        contactId: contactId,
        otp: otp,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
