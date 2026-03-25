import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_entity.freezed.dart';

@freezed
class ContactEntity with _$ContactEntity {
  const factory ContactEntity({
    required String id,
    required String name,
    required String email,
    required String contact,
    required String relation,
  }) = _ContactEntity;
}
