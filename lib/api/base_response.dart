import 'package:client/model/healthcheck.dart';
import 'package:client/model/user.dart';
import 'package:client/model/error.dart';
import 'package:client/model/user_page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(createToJson: false)
class BaseResponse {
  User? user;

  UserPage? userPage;

  Error? error;

  Healthcheck? healthcheck;

  static BaseResponse fromJson(dynamic json) => _$BaseResponseFromJson(json);
}
