import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/contacts/domain/entities/contact_entity.dart';
import 'package:locked_in/features/contacts/domain/entities/contacts_list_entity.dart';
import 'package:locked_in/features/contacts/domain/repositories/contact_repository.dart';
import 'package:locked_in/features/contacts/data/datasources/contact_remote_data_source.dart';

@LazySingleton(as: ContactRepository)
class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource _remoteDataSource;

  ContactRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ContactEntity>> addContact({
    required String name,
    required String email,
    required String contact,
    required String relation,
  }) async {
    try {
      final contactModel = await _remoteDataSource.addContact(
        name: name,
        email: email,
        contact: contact,
        relation: relation,
      );
      return Right(contactModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContactsListEntity>> getContacts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await _remoteDataSource.getContacts(
        page: page,
        limit: limit,
      );
      return Right(
        ContactsListEntity(
          contacts: result.contacts.map((m) => m.toEntity()).toList(),
          total: result.pagination.total,
          page: result.pagination.page,
          totalPage: result.pagination.totalPage,
          limit: result.pagination.limit,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
