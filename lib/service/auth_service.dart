import 'dart:io';
import 'package:dio/dio.dart';
import '../core/api/api_interceptors.dart';
import '../core/api/dio_consumer.dart';
import '../core/errors/error_model.dart';
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
  Future<void> login({required String phone, required String password}) async {
    try {
      final response = await apiConsumer.post(
        '/api/login',
        data: {"phone": phone, "password": password},
      );

      print("🔥 FULL RESPONSE: $response");

      // إذا response فارغ أو ما فيه data → خطأ
      if (response == null || response["data"] == null) {
        throw SereverException(
          errModel: ErrorModel(status: 400, errorMessage: "Invalid Credntials"),
        );
      }

      // تحقق من رسالة النجاح
      if (response["message"] == "User Logged In Successfully .") {
        // كل شيء تمام، ممكن تخزن الـ access_token لو بدك
        return;
      }

      // أي شيء غير كده → خطأ
      throw SereverException(
        errModel: ErrorModel(status: 400, errorMessage: "Invalid Credntials"),
      );
    } on DioException catch (e) {
      throw SereverException(
        errModel: ErrorModel(status: 400, errorMessage: "Invalid Credntials"),
      );
    } catch (e) {
      throw SereverException(
        errModel: ErrorModel(status: 400, errorMessage: "Invalid Credntials"),
      );
    }
  }

  // 3️⃣ دالة signup
  Future<void> signup({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String birthDate,
    File? profileImage,
    File? idImage,
    required int role,
  }) async {
    try {
      FormData formData = FormData();
      String formattedDate = birthDate.split('/').reversed.join('-');
      formData.fields
        ..add(MapEntry('first_name', firstName))
        ..add(MapEntry('last_name', lastName))
        ..add(MapEntry('phone', phone))
        ..add(MapEntry('password', password))
        ..add(MapEntry('date_of_birth', birthDate))
        ..add(MapEntry('role', role.toString()));

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
      print("💡 Signup Data:");
      for (var field in formData.fields) {
        print("${field.key}: ${field.value}");
      }
      for (var file in formData.files) {
        print("${file.key}: ${file.value.filename}");
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
