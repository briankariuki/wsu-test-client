import 'dart:convert';

import 'package:client/api/base_response.dart';
import 'package:client/config/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

_parseAndDecode(String response) {
  return BaseResponse.fromJson(jsonDecode(response));
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class BaseDio with DioMixin implements Dio {
  BaseDio() {
    httpClientAdapter = HttpClientAdapter();

    transformer = BackgroundTransformer()..jsonDecodeCallback = parseJson;

    interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ));

    interceptors.add(QueuedInterceptorsWrapper(onRequest: (options, handler) async {
      // options.headers.addAll(headers);

      handler.next(options);
    }, onResponse: (response, handler) {
      handler.next(response);
    }, onError: (error, handler) async {
      handler.next(error);
    }));
  }

  @override
  BaseOptions get options => BaseOptions(
        baseUrl: kBaseApiUrl,
        followRedirects: false,
        connectTimeout: const Duration(
          seconds: 60,
        ),
        sendTimeout: const Duration(
          seconds: 60,
        ),
        receiveTimeout: const Duration(
          seconds: 60,
        ),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        listFormat: ListFormat.multiCompatible,
      );
}
