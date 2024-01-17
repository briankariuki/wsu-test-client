import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'healthcheck.g.dart';

@JsonSerializable()
class Healthcheck {
  late String? message;
  late ApiStatus? status;
  late DateTime? date;

  static Healthcheck fromJson(dynamic json) => _$HealthcheckFromJson(json);

  static Healthcheck fromString(String json) => _$HealthcheckFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$HealthcheckToJson(this);
}

enum ApiStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
}

extension ApiStatusExtension on ApiStatus {
  String get description {
    switch (this) {
      case ApiStatus.active:
        return 'active';
      case ApiStatus.inactive:
        return 'inactive';
    }
  }
}
