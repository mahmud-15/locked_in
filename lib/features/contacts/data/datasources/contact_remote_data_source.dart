import 'package:injectable/injectable.dart';
import 'package:locked_in/core/network/api_service.dart';
import 'package:locked_in/features/contacts/data/models/contact_model.dart';
import 'package:locked_in/core/constants/api_endpoints.dart';

abstract class ContactRemoteDataSource {
  Future<ContactModel> addContact({
    required String name,
    required String email,
    required String contact,
    required String relation,
  });
}

@LazySingleton(as: ContactRemoteDataSource)
class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  @override
  Future<ContactModel> addContact({
    required String name,
    required String email,
    required String contact,
    required String relation,
  }) async {
    final response = await ApiService.post(
      '/contact',
      body: {
        'name': name,
        'email': email,
        'contact': contact,
        'relation': relation,
      },
    );

    if (response.isSuccess) {
      if (response.data['data'] != null) {
        return ContactModel.fromJson(response.data['data']);
      }
      // Provide some fallback or throw if data is crucial
      throw Exception("Contact created but no data returned.");
    } else {
      throw Exception(response.message);
    }
  }
}
