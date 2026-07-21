import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/contacts/domain/entities/contact_entity.dart';
import 'package:locked_in/features/contacts/domain/entities/contacts_list_entity.dart';

abstract class ContactRepository {
  Future<Either<Failure, ContactEntity>> addContact({
    required String name,
    required String email,
    required String contact,
    required String relation,
  });

  Future<Either<Failure, ContactsListEntity>> getContacts({
    int page = 1,
    int limit = 10,
  });
}
