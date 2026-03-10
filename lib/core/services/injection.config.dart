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
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
        () => _i107.AuthRemoteDataSourceImpl(gh<_i361.Dio>()));
    return this;
  }
}

class _$RegisterModule extends _i667.RegisterModule {}
