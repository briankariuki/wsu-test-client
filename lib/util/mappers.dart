import 'package:client/api/base_response.dart';
import 'package:client/model/app_error.dart';
import 'package:dio/dio.dart';

abstract class Mappers {
  static AppError errorToAppError(Object e, StackTrace s) {
    if (e is DioException) {
      var message = '';

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          message = 'Connection timeout. Try again';

          break;
        case DioExceptionType.sendTimeout:
          message = 'Request took too long. Try again';
          break;
        case DioExceptionType.receiveTimeout:
          message = 'Response took too long. Try again';
          break;
        case DioExceptionType.badResponse:
          if (e.response?.data is BaseResponse) {
            message = '${(e.response?.data as BaseResponse).error?.message}';
          } else {
            message = 'Response error. Try again';
          }
          break;
        case DioExceptionType.cancel:
          message = 'Request cancelled. Try again';
          break;
        default:
          message = 'An error occured. Try again';

          if (e.toString().contains('Network is unreachable') || e.toString().contains('Connection refused') || e.toString().contains('Http status error')) {
            message = 'Connection failed';
          }
          break;
      }

      return AppError(
        message: message,
        error: e,
        stackTrace: s,
      );
    }

    return AppError(
      message: e.toString(),
      error: e,
      stackTrace: s,
    );
  }
}
