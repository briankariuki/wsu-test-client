import 'dart:convert';

import 'package:client/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_page.g.dart';

@JsonSerializable()
class UserPage {
  late List<User> docs;
  late int totalDocs;
  late int limit;
  late bool hasPrevPage;
  late bool hasNextPage;
  late int? page;
  late int? totalPages;
  late int? offset;
  late int? prevPage;
  late int? nextPage;
  late int? pagingCounter;

  late List<User>? users;

  static UserPage fromJson(dynamic json) => _$UserPageFromJson(json);

  static UserPage fromString(String json) => _$UserPageFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$UserPageToJson(this);
}
