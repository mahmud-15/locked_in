import 'package:injectable/injectable.dart';
import 'package:locked_in/features/auth/data/models/user_model.dart';
import 'package:locked_in/core/network/api_service.dart';
import 'package:locked_in/core/constants/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> verifyEmail(String email, String oneTimeCode);
  Future<void> resendOtp(String email);
  Future<UserModel> login(String email, String password);
  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  );
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> register(String name, String email, String password) async {
    final response = await ApiService.post(
      ApiEndpoints.register,
      body: {'name': name, 'email': email, 'password': password},
    );

    if (response.isSuccess) {
      if (response.data['data'] != null) {
        return UserModel.fromJson(response.data['data']);
      }
      return const UserModel(
        id: '0',
        email: 'registered@app.com',
      ); // fallback if no user returned
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Future<UserModel> verifyEmail(String email, String oneTimeCode) async {
    final response = await ApiService.post(
      ApiEndpoints.verifyEmail,
      body: {'email': email, 'oneTimeCode': int.tryParse(oneTimeCode) ?? 0},
    );

    if (response.isSuccess) {
      if (response.data['data'] != null) {
        return UserModel.fromJson(response.data['data']);
      }
      return UserModel(id: '0', email: email); // fallback
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Future<void> resendOtp(String email) async {
    final response = await ApiService.post(
      ApiEndpoints.resendOtp,
      body: {'email': email},
    );

    if (!response.isSuccess) {
      throw Exception(response.message);
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await ApiService.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
    );

    if (response.isSuccess) {
      return UserModel.fromJson(response.data['data'] ?? response.data);
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final response = await ApiService.post(
      ApiEndpoints.changePassword,
      body: {
        'oldPassword': oldPassword,
        'currentPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );

    if (!response.isSuccess) {
      throw Exception(response.message);
    }
  }
}
