// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactModelImpl _$$ContactModelImplFromJson(Map<String, dynamic> json) =>
    _$ContactModelImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      contact: json['contact'] as String,
      relation: json['relation'] as String,
    );

Map<String, dynamic> _$$ContactModelImplToJson(_$ContactModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'contact': instance.contact,
      'relation': instance.relation,
    };
