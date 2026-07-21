import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/features/auth/data/models/user_model.dart';
import 'package:locked_in/core/network/api_service.dart';
import 'package:locked_in/core/constants/api_endpoints.dart';
import 'package:locked_in/core/services/injection.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(String name);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<UserModel> getProfile() async {
    final response = await ApiService.get(ApiEndpoints.profile);

    if (response.isSuccess) {
      return UserModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Future<UserModel> updateProfile(String name) async {
    final response = await ApiService.patch(
      ApiEndpoints.profile,
      body: {'name': name},
    );

    if (response.isSuccess) {
      final data = response.data['data'];
      if (data is Map) {
        return UserModel.fromJson(Map<String, dynamic>.from(data));
      }
      return getProfile();
    } else {
      throw Exception(response.message);
    }
  }
}

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return getIt<ProfileRemoteDataSource>();
});
