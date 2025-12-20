import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/my_account_controller.dart';
import '../core/api/dio_consumer.dart';
import '../core/errors/error_model.dart';
import '../core/errors/exceptions.dart';
import '../core/api/end_points.dart';

class AuthService {
  final DioConsumer api;

  AuthService({required this.api});

  Future<String> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await api.dio.post(
        EndPoint.logIn,
        data: {"phone": phone, "password": password},
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data["message"] == "User Logged In Successfully .") {
          final userData = data["data"];
          final token = userData["access_token"];

          if (token == null) {
            throw ServerException(
              errModel: ErrorModel(errorMessage: "Token missing from server!"),
            );
          }
          // save data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", token);
          String roleString;
          if (userData["role"].toString() == '3' ||
              userData["role"] == 'owner') {
            roleString = 'owner';
          } else if (userData["role"].toString() == '2' ||
              userData["role"] == 'renter') {
            roleString = 'renter';
          } else {
            roleString = 'admin';
          }
          await prefs.setString("role", roleString);
          await prefs.setString("id", userData["id"]?.toString() ?? "");
          await prefs.setString("first_name", userData["first_name"] ?? "");
          await prefs.setString("last_name", userData["last_name"] ?? "");
          await prefs.setString("phone", userData["phone"] ?? "");
          await prefs.setString(
            "date_of_birth",
            userData["date_of_birth"] ?? "",
          );

          // تخزين روابط الصور
          if (userData["profile_image"] != null) {
            await prefs.setString(
              "profile_image",
              userData["profile_image"]["url"]?.toString() ?? "",
            );
          }
          if (userData["id_image"] != null) {
            await prefs.setString(
              "id_image",
              userData["id_image"]["url"]?.toString() ?? "",
            );
          }
          return token;
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
    required String role,
  }) async {
    try {
      print("Starting signup process...");

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
      final roleNumber = role == 'owner' ? 3 : 2;

      final formData = FormData();

      // إضافة البيانات النصية
      formData.fields.addAll([
        MapEntry('first_name', firstName),
        MapEntry('last_name', lastName),
        MapEntry('phone', phone),
        MapEntry('password', password),
        MapEntry('password_confirmation', confirmPassword),
        MapEntry('role', roleNumber.toString()),
        MapEntry('date_of_birth', formattedDate),
      ]);

      // إضافة ملفات الصور إذا كانت موجودة
      if (profileImage != null && profileImage.existsSync()) {
        formData.files.add(
          MapEntry(
            'profile_image',
            await MultipartFile.fromFile(
              profileImage.path,
              filename: "profile_${DateTime.now().millisecondsSinceEpoch}.jpg",
            ),
          ),
        );
      }

      if (idImage != null && idImage.existsSync()) {
        formData.files.add(
          MapEntry(
            'id_image',
            await MultipartFile.fromFile(
              idImage.path,
              filename: "id_${DateTime.now().millisecondsSinceEpoch}.jpg",
            ),
          ),
        );
      }

      final response = await api.post(
        EndPoint.signUp,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => status! < 500,
        ),
      );

      print("Server response: $response");

      if (response != null &&
          response is Map &&
          (response["message"]?.toString().contains("Successfully") == true ||
              response["status"] == "success")) {
        print("Signup successful!");

        final userData = response["data"] ?? response;
        final token = userData["access_token"];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", token);
          await prefs.setString("role", role); // owner | renter
          await prefs.setString("id", userData["id"]?.toString() ?? "");
          await prefs.setString("first_name", firstName);
          await prefs.setString("last_name", lastName);
          await prefs.setString("phone", phone);
          await prefs.setString("date_of_birth", formattedDate);
          // ✅ حل مشكلة الصور: التحقق بشكل أفضل من وجود الصور
          String profileImageUrl = "";
          String idImageUrl = "";

          if (userData["profile_image"] != null) {
            if (userData["profile_image"] is Map) {
              profileImageUrl =
                  userData["profile_image"]["url"]?.toString() ?? "";
            } else if (userData["profile_image"] is String) {
              profileImageUrl = userData["profile_image"];
              // ✅ إصلاح الرابط إذا كان نسبياً
              if (profileImageUrl.startsWith('/storage/')) {
                profileImageUrl = 'http://10.0.2.2:8000$profileImageUrl';
              } else if (profileImageUrl.startsWith('storage/')) {
                profileImageUrl =
                    'http://10.0.2.2:8000/storage/$profileImageUrl';
              }
            }

            if (profileImageUrl.isNotEmpty) {
              await prefs.setString("profile_image", profileImageUrl);
              print("✅ Profile image saved: $profileImageUrl");
            }
          }

          if (userData["id_image"] != null) {
            if (userData["id_image"] is Map) {
              idImageUrl = userData["id_image"]["url"]?.toString() ?? "";
            } else if (userData["id_image"] is String) {
              idImageUrl = userData["id_image"];
              // ✅ إصلاح الرابط إذا كان نسبياً
              if (idImageUrl.startsWith('/storage/')) {
                idImageUrl = 'http://10.0.2.2:8000$idImageUrl';
              } else if (idImageUrl.startsWith('storage/')) {
                idImageUrl = 'http://10.0.2.2:8000/storage/$idImageUrl';
              }
            }

            if (idImageUrl.isNotEmpty) {
              await prefs.setString("id_image", idImageUrl);
              print("✅ ID image saved: $idImageUrl");
            }
          }

          // تحديث MyAccountController مباشرة بعد التسجيل
          try {
            if (Get.isRegistered<MyAccountController>()) {
              await Get.find<MyAccountController>().updateUserAfterSignup({
                'id': userData["id"]?.toString() ?? "",
                'first_name': firstName,
                'last_name': lastName,
                'phone': phone,
                'role': role,
                'date_of_birth': formattedDate,
                'profile_image': profileImageUrl,
                'id_image': idImageUrl,
                'token': token,
              });
            }
          } catch (e) {
            print("Could not update MyAccountController: $e");
          }
        } else {
          print("Warning: No token returned from signup");
        }

        return;
      } else {
        final errorMsg = response is Map
            ? (response["message"]?.toString() ??
                  response["error"]?.toString() ??
                  "Signup failed")
            : "Signup failed - Invalid response";
        throw ServerException(errModel: ErrorModel(errorMessage: errorMsg));
      }
    } on DioException catch (e) {
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

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("token");
    await prefs.remove("id");
    await prefs.remove("first_name");
    await prefs.remove("last_name");
    await prefs.remove("phone");
    await prefs.remove("role");
    await prefs.remove("date_of_birth");

    print(" User logged out successfully (local data cleared)");
  }
}
