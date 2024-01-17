// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'healthcheck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Healthcheck _$HealthcheckFromJson(Map<String, dynamic> json) => Healthcheck()
  ..message = json['message'] as String?
  ..status = $enumDecodeNullable(_$ApiStatusEnumMap, json['status'])
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String);

Map<String, dynamic> _$HealthcheckToJson(Healthcheck instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': _$ApiStatusEnumMap[instance.status],
      'date': instance.date?.toIso8601String(),
    };

const _$ApiStatusEnumMap = {
  ApiStatus.active: 'active',
  ApiStatus.inactive: 'inactive',
};
