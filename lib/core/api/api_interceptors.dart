import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = "en";
  }
}
