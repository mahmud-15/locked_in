import 'package:locked_in/features/contacts/domain/entities/contact_entity.dart';

class ContactsListEntity {
  final List<ContactEntity> contacts;
  final int total;
  final int page;
  final int totalPage;
  final int limit;

  const ContactsListEntity({
    required this.contacts,
    required this.total,
    required this.page,
    required this.totalPage,
    required this.limit,
  });

  bool get hasNextPage => page < totalPage;
}
