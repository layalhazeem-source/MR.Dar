import 'dart:io';
import 'package:dio/dio.dart';
import '../core/api/api_interceptors.dart';
import '../core/api/dio_consumer.dart';
import '../core/errors/exceptions.dart';
import '../core/api/end_points.dart'; // مهم جداً

class AuthService {
  late final Dio dio;
  late final DioConsumer apiConsumer;

  AuthService() {
    dio =
        Dio(
            BaseOptions(
              baseUrl: EndPoint.baseUrl, // <<<<< غيّريه من end_points.dart
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 5),
            ),
          )
          ..interceptors.add(ApiInterceptor())
          ..interceptors.add(
            LogInterceptor(
              request: true,
              requestBody: true,
              responseBody: true,
              error: true,
            ),
          );

    apiConsumer = DioConsumer(dio: dio);
  }

  // 2️⃣ دالة login
  Future<void> login({required String phone, required String password}) async {
    print("🔥 AuthService.login reached");

    try {
      final response = await apiConsumer.post(
        '/api/login',
        data: {"phone": phone, "password": password},
      );

      print("🔥 API Response: $response");
    } catch (e) {
      print("❌ ERROR in AuthService.login: $e");
      rethrow;
    }
  }

  // 3️⃣ دالة signup
  Future<void> signup({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String birthDate,
    required String userType,
    File? profileImage,
    File? idImage,
  }) async {
    try {
      FormData formData = FormData();

      formData.fields
        ..add(MapEntry('first_name', firstName))
        ..add(MapEntry('last_name', lastName))
        ..add(MapEntry('phone', phone))
        ..add(MapEntry('password', password))
        ..add(MapEntry('date_of_birth', birthDate));
      // ..add(MapEntry('userType', userType));

      if (profileImage != null) {
        formData.files.add(
          MapEntry(
            'profileImage',
            await MultipartFile.fromFile(
              profileImage.path,
              filename: profileImage.path.split('/').last,
            ),
          ),
        );
      }

      if (idImage != null) {
        formData.files.add(
          MapEntry(
            'idImage',
            await MultipartFile.fromFile(
              idImage.path,
              filename: idImage.path.split('/').last,
            ),
          ),
        );
      }

      final response = await apiConsumer.post(
        '/api/register', // غيريه للـ endpoint الصحيح
        data: formData,
      );

      print('Signup success: $response');
    } on SereverException catch (e) {
      print('Signup failed: ${e.errModel.errorMessage}');
      throw e;
    }
  }
}
