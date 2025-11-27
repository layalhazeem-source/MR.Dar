import 'error_model.dart';
import 'package:dio/dio.dart';

class SereverException implements Exception {
  final ErrorModel errModel;

  SereverException({required this.errModel});
}

void handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw SereverException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.sendTimeout:
      throw SereverException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.receiveTimeout:
      throw SereverException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.badCertificate:
      throw SereverException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.cancel:
      throw SereverException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.connectionError:
      throw SereverException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.unknown:
      throw SereverException(errModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
          throw SereverException(
            errModel: ErrorModel.fromJson(e.response!.data),
          );
        case 401:
          throw SereverException(
            errModel: ErrorModel.fromJson(e.response!.data),
          );
        case 403:
          throw SereverException(
            errModel: ErrorModel.fromJson(e.response!.data),
          );
        case 404:
          throw SereverException(
            errModel: ErrorModel.fromJson(e.response!.data),
          );
        case 409:
          throw SereverException(
            errModel: ErrorModel.fromJson(e.response!.data),
          );
        case 422:
          throw SereverException(
            errModel: ErrorModel.fromJson(e.response!.data),
          );
        case 504:
          throw SereverException(
            errModel: ErrorModel.fromJson(e.response!.data),
          );
      }
  }
}
