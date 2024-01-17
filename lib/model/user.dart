import 'dart:convert';

import 'package:client/api/base_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends BaseObject {
  late String? uid;
  late String? displayName;
  late String? username;
  late String? email;
  late String? phoneNumber;
  late UserStatus? status;
  late bool? verified;

  String get firstName => displayName!.split(' ').first;
  String get avatar => displayName!.split('').first;

  static User fromJson(dynamic json) => _$UserFromJson(json);

  static User fromString(String json) => _$UserFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

enum UserStatus {
  @JsonValue('active')
  active,
  @JsonValue('blocked')
  blocked,
}

extension UserStatusExtension on UserStatus {
  String get description {
    switch (this) {
      case UserStatus.active:
        return 'active';
      case UserStatus.blocked:
        return 'blocked';
    }
  }
}
