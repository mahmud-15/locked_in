import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';
import 'package:locked_in/features/auth/domain/repositories/auth_repository.dart';
import 'package:locked_in/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:locked_in/core/network/local_storage.dart';

import 'package:locked_in/core/services/storage_service.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  AuthRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userModel = await _remoteDataSource.register(name, email, password);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyEmail(
    String email,
    String oneTimeCode,
  ) async {
    try {
      final userModel = await _remoteDataSource.verifyEmail(email, oneTimeCode);
      if (userModel.accessToken != null) {
        await _storageService.write('token', userModel.accessToken!);
        LocalStorage.token = userModel.accessToken;
      }
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(String email) async {
    try {
      await _remoteDataSource.resendOtp(email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _remoteDataSource.login(email, password);
      if (userModel.accessToken != null) {
        await _storageService.write('token', userModel.accessToken!);
        LocalStorage.token = userModel.accessToken;
      }
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await _storageService.delete('token');
    LocalStorage.token = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    return Left(ServerFailure("Not implemented"));
  }
}
