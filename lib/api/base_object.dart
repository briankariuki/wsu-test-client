import 'package:json_annotation/json_annotation.dart';

abstract class BaseObject {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: '__t')
  String? t;

  @JsonKey(name: '__v')
  int? v;

  DateTime? createdAt;

  DateTime? updatedAt;

  bool? deleted;

  bool get hide => deleted == true;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool selected = false;

  @override
  String toString() {
    return id ?? super.toString();
  }
}
