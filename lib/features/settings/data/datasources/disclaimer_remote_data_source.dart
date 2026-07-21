import 'package:locked_in/core/constants/api_endpoints.dart';
import 'package:locked_in/core/network/api_service.dart';

class DisclaimerRemoteDataSource {
  Future<String> getDisclaimer(String type) async {
    final response = await ApiService.get(
      '${ApiEndpoints.disclaimer}?type=$type',
    );

    if (response.isSuccess) {
      return response.data['data'] as String;
    } else {
      throw Exception(response.message);
    }
  }
}
