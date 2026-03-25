import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> register(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> verifyEmail(
    String email,
    String oneTimeCode,
  );
  Future<Either<Failure, void>> resendOtp(String email);
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity>> getCurrentUser();
}
