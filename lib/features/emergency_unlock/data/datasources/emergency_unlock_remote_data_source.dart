import 'package:injectable/injectable.dart';
import 'package:locked_in/core/network/api_service.dart';

abstract class EmergencyUnlockRemoteDataSource {
  Future<String> requestOtp({
    required String appName,
    required String contactId,
    required String message,
  });

  Future<String> verifyOtp({
    required String appName,
    required String contactId,
    required int otp,
  });
}

@LazySingleton(as: EmergencyUnlockRemoteDataSource)
class EmergencyUnlockRemoteDataSourceImpl
    implements EmergencyUnlockRemoteDataSource {
  @override
  Future<String> requestOtp({
    required String appName,
    required String contactId,
    required String message,
  }) async {
    final response = await ApiService.post(
      '/contact/otp-request',
      body: {'appName': appName, 'contactId': contactId, 'message': message},
    );

    if (response.isSuccess) {
      return response.data['message']?.toString() ??
          'Request sent successfully';
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Future<String> verifyOtp({
    required String appName,
    required String contactId,
    required int otp,
  }) async {
    final response = await ApiService.post(
      '/contact/verify-otp',
      body: {'appName': appName, 'contactId': contactId, 'otp': otp},
    );

    if (response.isSuccess) {
      return response.data['message']?.toString() ??
          'OTP verified successfully';
    } else {
      throw Exception(response.message);
    }
  }
}
