import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/contacts/domain/entities/contact_entity.dart';
import 'package:locked_in/features/contacts/domain/repositories/contact_repository.dart';

@injectable
class AddContactUseCase {
  final ContactRepository _repository;

  AddContactUseCase(this._repository);

  Future<Either<Failure, ContactEntity>> call(AddContactParams params) {
    return _repository.addContact(
      name: params.name,
      email: params.email,
      contact: params.contact,
      relation: params.relation,
    );
  }
}

class AddContactParams {
  final String name;
  final String email;
  final String contact;
  final String relation;

  AddContactParams({
    required this.name,
    required this.email,
    required this.contact,
    required this.relation,
  });
}
