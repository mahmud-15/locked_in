import 'package:fpdart/fpdart.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/contacts/domain/entities/contact_entity.dart';

abstract class ContactRepository {
  Future<Either<Failure, ContactEntity>> addContact({
    required String name,
    required String email,
    required String contact,
    required String relation,
  });
}
