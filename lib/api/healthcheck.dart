import 'package:client/api/base_dio.dart';
import 'package:client/api/base_response.dart';
import 'package:dio/dio.dart';

class HealthcheckApi extends BaseDio {
  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) => get('api/healthcheck', queryParameters: query);
}
