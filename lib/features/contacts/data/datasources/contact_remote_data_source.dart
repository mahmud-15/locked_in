import 'package:injectable/injectable.dart';
import 'package:locked_in/core/network/api_service.dart';
import 'package:locked_in/features/contacts/data/models/contact_model.dart';
import 'package:locked_in/features/contacts/data/models/contacts_list_model.dart';

abstract class ContactRemoteDataSource {
  Future<ContactModel> addContact({
    required String name,
    required String email,
    required String contact,
    required String relation,
  });

  Future<GetContactsResponse> getContacts({int page = 1, int limit = 10});
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
      throw Exception("Contact created but no data returned.");
    } else {
      throw Exception(response.message);
    }
  }

  @override
  Future<GetContactsResponse> getContacts({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await ApiService.get('/contact?page=$page&limit=$limit');

    if (response.isSuccess) {
      final data = response.data;
      final pagination = PaginationMeta.fromJson(
        data['pagination'] as Map<String, dynamic>,
      );
      final contacts = (data['data'] as List)
          .map((e) => ContactModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return GetContactsResponse(contacts: contacts, pagination: pagination);
    } else {
      throw Exception(response.message);
    }
  }
}

class GetContactsResponse {
  final List<ContactModel> contacts;
  final PaginationMeta pagination;
  GetContactsResponse({required this.contacts, required this.pagination});
}
