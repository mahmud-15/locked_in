import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/settings/data/datasources/profile_remote_data_source.dart';
import 'package:locked_in/features/settings/domain/repositories/profile_repository.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final model = await _remoteDataSource.getProfile();
      return right(model.toEntity());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(String name) async {
    try {
      final model = await _remoteDataSource.updateProfile(name);
      return right(model.toEntity());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
