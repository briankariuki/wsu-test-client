import 'dart:convert';

import 'package:client/api/base_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends BaseObject {
  late String? firstName;
  late String? lastName;
  late String? email;
  late UserStatus? status;

  String get avatar => firstName!.split('').first;

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
