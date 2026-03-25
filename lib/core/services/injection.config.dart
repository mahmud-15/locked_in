// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/register_usecase.dart' as _i941;
import '../../features/auth/domain/usecases/resend_otp_usecase.dart' as _i613;
import '../../features/auth/domain/usecases/verify_email_usecase.dart' as _i30;
import '../../features/contacts/data/datasources/contact_remote_data_source.dart'
    as _i971;
import '../../features/contacts/data/repositories/contact_repository_impl.dart'
    as _i929;
import '../../features/contacts/domain/repositories/contact_repository.dart'
    as _i873;
import '../../features/contacts/domain/usecases/add_contact_usecase.dart'
    as _i834;
import '../network/dio_client.dart' as _i667;
import 'hive_service.dart' as _i0;
import 'storage_service.dart' as _i285;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i0.HiveService>(() => _i0.HiveService());
    gh.lazySingleton<_i285.StorageService>(() => _i285.StorageService());
    gh.lazySingleton<_i971.ContactRemoteDataSource>(
        () => _i971.ContactRemoteDataSourceImpl());
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
        () => _i107.AuthRemoteDataSourceImpl());
    gh.lazySingleton<_i873.ContactRepository>(
        () => _i929.ContactRepositoryImpl(gh<_i971.ContactRemoteDataSource>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i107.AuthRemoteDataSource>(),
          gh<_i285.StorageService>(),
        ));
    gh.factory<_i941.RegisterUseCase>(
        () => _i941.RegisterUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i30.VerifyEmailUseCase>(
        () => _i30.VerifyEmailUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i613.ResendOtpUseCase>(
        () => _i613.ResendOtpUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i188.LoginUseCase>(
        () => _i188.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i834.AddContactUseCase>(
        () => _i834.AddContactUseCase(gh<_i873.ContactRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i667.RegisterModule {}
