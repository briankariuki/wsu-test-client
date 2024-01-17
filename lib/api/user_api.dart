import 'package:client/api/base_dio.dart';
import 'package:client/api/base_response.dart';
import 'package:dio/dio.dart';

class UserApi extends BaseDio {
  Future<Response<BaseResponse>> create(Map<String, dynamic> data) => post('v1/user/', data: data);

  Future<Response<BaseResponse>> update(String userId, Map<String, dynamic> data) => put('v1/user/$userId', data: data);

  Future<Response<BaseResponse>> retrieve(Map<String, dynamic> query) => get('v1/user', queryParameters: query);

  Future<Response<BaseResponse>> remove(String userId) => delete('v1/user/$userId');
}
