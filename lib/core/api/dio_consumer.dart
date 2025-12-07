import 'package:new_project/core/api/api_consumer.dart';
import 'package:dio/dio.dart';
import 'package:new_project/core/api/api_interceptors.dart';
import 'package:new_project/core/api/end_points.dart';
import 'package:new_project/core/errors/exceptions.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoint.baseUrl;
    dio.interceptors.add(ApiInterceptor()); //مراقبة ال request وال response
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        error: true,
      ),
    ); //يراقب ال request وال response ويطبعهم بال console
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
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );
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

      // رجّع response كامل لو حبيت أو response.data حسب تصميمك.
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
