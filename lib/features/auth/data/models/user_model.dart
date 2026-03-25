import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:locked_in/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') String? id,
    String? email,
    String? name,
    @JsonKey(name: 'image') String? photoUrl,
    String? accessToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  const UserModel._();

  UserEntity toEntity() => UserEntity(
    id: id ?? '',
    email: email ?? '',
    name: name,
    photoUrl: photoUrl,
    accessToken: accessToken,
  );
}
