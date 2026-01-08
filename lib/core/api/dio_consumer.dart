import 'package:new_project/core/api/api_consumer.dart';
import 'package:dio/dio.dart';
import 'package:new_project/core/api/api_interceptors.dart';
import 'package:new_project/core/api/end_points.dart';
import 'package:new_project/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoint.baseUrl;
    dio.interceptors.add(ApiInterceptor());

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString("token");

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        error: true,
      ),
    ); //مراقبة ال request وال response
  }

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormDatta = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFormDatta ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);

      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormDatta = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormDatta ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
    bool isFormDatta = false,
  }) async {
    try {
      final payload = isFormDatta
          ? (data is FormData
                ? data
                : FormData.fromMap(Map<String, dynamic>.from(data ?? {})))
          : data;

      final response = await dio.post(
        path,
        data: payload,
        queryParameters: queryParameters,
        options: options,
      );

      // print(response.data)
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }


}
