import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/contacts/domain/entities/contacts_list_entity.dart';
import 'package:locked_in/features/contacts/domain/repositories/contact_repository.dart';

@injectable
class GetContactsUseCase {
  final ContactRepository _repository;

  GetContactsUseCase(this._repository);

  Future<Either<Failure, ContactsListEntity>> call({
    int page = 1,
    int limit = 10,
  }) {
    return _repository.getContacts(page: page, limit: limit);
  }
}
