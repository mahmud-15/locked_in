// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['_id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      photoUrl: json['image'] as String?,
      accessToken: json['accessToken'] as String?,
      subscription: json['subscription'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'image': instance.photoUrl,
      'accessToken': instance.accessToken,
      'subscription': instance.subscription,
    };
