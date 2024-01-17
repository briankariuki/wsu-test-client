// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Error _$ErrorFromJson(Map<String, dynamic> json) => Error()
  ..message = json['message'] as String?
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String);

Map<String, dynamic> _$ErrorToJson(Error instance) => <String, dynamic>{
      'message': instance.message,
      'date': instance.date?.toIso8601String(),
    };
