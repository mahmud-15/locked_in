import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:locked_in/core/errors/failures.dart';
import 'package:locked_in/features/contacts/domain/entities/contact_entity.dart';
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
}
