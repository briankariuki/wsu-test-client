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
  ..uid = json['uid'] as String?
  ..displayName = json['displayName'] as String?
  ..username = json['username'] as String?
  ..email = json['email'] as String?
  ..phoneNumber = json['phoneNumber'] as String?
  ..status = $enumDecodeNullable(_$UserStatusEnumMap, json['status'])
  ..verified = json['verified'] as bool?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      '__t': instance.t,
      '__v': instance.v,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deleted': instance.deleted,
      'uid': instance.uid,
      'displayName': instance.displayName,
      'username': instance.username,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'status': _$UserStatusEnumMap[instance.status],
      'verified': instance.verified,
    };

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.blocked: 'blocked',
};
