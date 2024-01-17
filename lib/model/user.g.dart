// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['_id'] as String?
  ..t = json['__t'] as String?
  ..v = json['__v'] as int?
  ..createdAt = json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String)
  ..updatedAt = json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String)
  ..deleted = json['deleted'] as bool?
  ..firstName = json['firstName'] as String?
  ..lastName = json['lastName'] as String?
  ..email = json['email'] as String?
  ..status = $enumDecodeNullable(_$UserStatusEnumMap, json['status']);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      '__t': instance.t,
      '__v': instance.v,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deleted': instance.deleted,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'status': _$UserStatusEnumMap[instance.status],
    };

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.blocked: 'blocked',
};
