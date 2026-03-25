import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:locked_in/features/contacts/domain/entities/contact_entity.dart';

part 'contact_model.freezed.dart';
part 'contact_model.g.dart';

@freezed
class ContactModel with _$ContactModel {
  const factory ContactModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    required String contact,
    required String relation,
  }) = _ContactModel;

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  const ContactModel._();

  ContactEntity toEntity() => ContactEntity(
    id: id,
    name: name,
    email: email,
    contact: contact,
    relation: relation,
  );
}
