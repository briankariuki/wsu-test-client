// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse()
  ..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>)
  ..userPage = json['userPage'] == null
      ? null
      : UserPage.fromJson(json['userPage'] as Map<String, dynamic>)
  ..error = json['error'] == null
      ? null
      : Error.fromJson(json['error'] as Map<String, dynamic>)
  ..healthcheck = json['healthcheck'] == null
      ? null
      : Healthcheck.fromJson(json['healthcheck'] as Map<String, dynamic>);
