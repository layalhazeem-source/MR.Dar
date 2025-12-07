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
      final response = await api.dio.post(
        EndPoint.logIn,
        data: {"phone": phone, "password": password},
        options: Options(validateStatus: (status) => true),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data["message"]?.toString().trim() ==
            "User Logged In Successfully .") {
          return;
        } else {
          throw ServerException(
            errModel: ErrorModel(errorMessage: "Invalid Credntials"),
          );
        }
      } else {
        String msg = "Invalid Credntials";
        try {
          msg = response.data["message"] ?? "Invalid Credntials";
        } catch (_) {}
        throw ServerException(errModel: ErrorModel(errorMessage: msg));
      }
    } on DioException catch (e) {
      throw ServerException(
        errModel: ErrorModel(errorMessage: "Network error: ${e.message}"),
      );
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
      print(" Starting signup process...");

      // 1. تحقق من تاريخ الميلاد
      if (!birthDate.contains('/')) {
        throw ServerException(
          errModel: ErrorModel(
            errorMessage: "Invalid date format. Use DD/MM/YYYY",
          ),
        );
      }

      final dateParts = birthDate.split('/');
      if (dateParts.length != 3) {
        throw ServerException(
          errModel: ErrorModel(
            errorMessage: "Date must be in format DD/MM/YYYY",
          ),
        );
      }
      final formattedDate =
          "${dateParts[2]}-${dateParts[1].padLeft(2, '0')}-${dateParts[0].padLeft(2, '0')}";
      print("Formatted date: $formattedDate");

      final formData = {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "password": password,
        "password_confirmation": confirmPassword,
        "role": role.toString(),
        "date_of_birth": formattedDate,
      };

      final Map<String, dynamic> dataToSend = Map.from(formData);

      if (profileImage != null && profileImage.existsSync()) {
        print(" Adding profile image...");
        dataToSend["profile_image"] = await MultipartFile.fromFile(
          profileImage.path,
          filename: "profile_${DateTime.now().millisecondsSinceEpoch}.jpg",
        );
      }

      if (idImage != null && idImage.existsSync()) {
        print(" Adding ID image...");
        dataToSend["id_image"] = await MultipartFile.fromFile(
          idImage.path,
          filename: "id_${DateTime.now().millisecondsSinceEpoch}.jpg",
        );
      }

      print("📤 Sending request to server...");

      final response = await api.post(
        EndPoint.signUp,
        data: FormData.fromMap(dataToSend),
        isFormDatta: true,
        options: Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => status! < 500,
        ),
      );

      print("✅ Server response received");
      print("Status Code: ${response?['status'] ?? 'N/A'}");
      print("Response: $response");

      if (response != null &&
          response is Map &&
          (response["message"]?.toString().contains("Successfully") == true ||
              response["status"] == "success")) {
        print(" Signup successful!");
        return;
      } else {
        final errorMsg = response is Map
            ? (response["message"]?.toString() ??
                  response["error"]?.toString() ??
                  "Signup failed")
            : "Signup failed - Invalid response";
        print(" Signup failed: $errorMsg");
        throw ServerException(errModel: ErrorModel(errorMessage: errorMsg));
      }
    } on DioException catch (e) {
      print(" Dio Error: ${e.message}");
      print("Response: ${e.response?.data}");

      String errorMessage = "Network error";
      if (e.response != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        errorMessage =
            data["message"]?.toString() ??
            data["error"]?.toString() ??
            e.message ??
            "Network error";
      }

      throw ServerException(errModel: ErrorModel(errorMessage: errorMessage));
    } catch (e, s) {
      print("Unexpected error: $e");
      print("Stack trace: $s");
      throw ServerException(
        errModel: ErrorModel(errorMessage: "Unexpected error: ${e.toString()}"),
      );
    }
  }
}
