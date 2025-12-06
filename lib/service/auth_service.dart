import 'dart:io';
import 'package:dio/dio.dart';
import '../core/api/dio_consumer.dart';
import '../core/errors/error_model.dart';
import '../core/errors/exceptions.dart';
import '../core/api/end_points.dart';

class AuthService {
  final DioConsumer api;
  AuthService({required this.api});

  Future<void> login({required String phone, required String password}) async {
    try {
      final response = await api.post(
        EndPoint.logIn,
        data: {"phone": phone, "password": password},
      );
      if (response == null ||
          response["message"] != "Logged In Successfully .") {
        throw ServerException(
          errModel: ErrorModel(
            errorMessage: response?["message"] ?? "Invalid Credntials",
          ),
        );
      }
      return;
    } on DioException catch (e) {
      handleDioException(e);
      rethrow;
    }
  }

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String confirmPassword,
    required String birthDate,
    File? profileImage,
    File? idImage,
    required int role,
  }) async {
    try {
      final formData = FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "password": password,
        "password_confirmation": confirmPassword,
        "role": role.toString(),
        "date_of_birth": birthDate.split('/').reversed.join('-'),
        if (profileImage != null)
          "profile_image": await MultipartFile.fromFile(profileImage.path),
        if (idImage != null)
          "id_image": await MultipartFile.fromFile(idImage.path),
      });

      final response = await api.post(EndPoint.signUp, data: formData);

      // إذا الـresponse ما نجحت، رمي استثناء
      if (response == null ||
          response["message"] != "User Created Successfully .") {
        throw ServerException(
          errModel: ErrorModel(
            errorMessage: response?["message"] ?? "Signup failed",
          ),
        );
      }
    } on DioException catch (e) {
      // هون بنستفيد من handleDioException مباشرة
      handleDioException(e);
    }
  }
}
