import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          // الوصول الصحيح للبيانات
          final userData = data["data"]; // كل البيانات في مفتاح "data"
          final token = userData["access_token"];

          if (token == null) {
            throw ServerException(
              errModel: ErrorModel(errorMessage: "Token missing from server!"),
            );
          }
          // حفظ البيانات بشكل صحيح
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", token);
          await prefs.setString("id", userData["id"]?.toString() ?? "");
          await prefs.setString("first_name", userData["first_name"] ?? "");
          await prefs.setString("last_name", userData["last_name"] ?? "");
          await prefs.setString("phone", userData["phone"] ?? "");
          await prefs.setString("role", userData["role"] ?? "");
          await prefs.setString(
            "date_of_birth",
            userData["date_of_birth"] ?? "",
          );

          print("✅ User data saved to SharedPreferences:");
          print("   ID: ${userData["id"]}");
          print("   Name: ${userData["first_name"]} ${userData["last_name"]}");
          print("   Phone: ${userData["phone"]}");
          print("   Role: ${userData["role"]}");

          return token; // ⬅️ رجع التوكن
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
      print("Starting signup process...");

      // التحقق من تاريخ الميلاد
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
        dataToSend["profile_image"] = await MultipartFile.fromFile(
          profileImage.path,
          filename: "profile_${DateTime.now().millisecondsSinceEpoch}.jpg",
        );
      }

      if (idImage != null && idImage.existsSync()) {
        dataToSend["id_image"] = await MultipartFile.fromFile(
          idImage.path,
          filename: "id_${DateTime.now().millisecondsSinceEpoch}.jpg",
        );
      }

      final response = await api.post(
        EndPoint.signUp,
        data: FormData.fromMap(dataToSend),
        isFormDatta: true,
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

        // ⬅️⬅️⬅️ **هنا المشكلة والحل** ⬅️⬅️⬅️
        // نحتاج حفظ بيانات المستخدم بنفس طريقة login
        final userData = response["data"] ?? response;
        final token = userData["access_token"];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();

          // 1. حفظ التوكن
          await prefs.setString("token", token);

          // 2. حفظ بيانات المستخدم **مثل ما يعمل الـ login بالضبط**
          await prefs.setString("id", userData["id"]?.toString() ?? "");
          await prefs.setString(
            "first_name",
            userData["first_name"] ?? firstName,
          );
          await prefs.setString("last_name", userData["last_name"] ?? lastName);
          await prefs.setString("phone", userData["phone"] ?? phone);
          await prefs.setString("role", userData["role"] ?? role.toString());
          await prefs.setString(
            "date_of_birth",
            userData["date_of_birth"] ?? formattedDate,
          );

          print("✅ User data saved to SharedPreferences after signup:");
          print("   ID: ${prefs.getString("id")}");
          print(
            "   Name: ${prefs.getString("first_name")} ${prefs.getString("last_name")}",
          );
          print("   Phone: ${prefs.getString("phone")}");
          print("   Role: ${prefs.getString("role")}");
          print("   Date of Birth: ${prefs.getString("date_of_birth")}");
          print("   Token saved: ${token.substring(0, 20)}...");
        } else {
          print("Warning: No token returned from signup");
        }

        return;
      } else {
        final errorMsg = response is Map
            ? (response["errors"]?["phone"] != null
                  ? response["errors"]["phone"][0].toString()
                  : response["message"]?.toString() ?? "Signup failed")
            : "Signup failed - Invalid response";

        throw ServerException(
          errModel: ErrorModel(
            errorMessage: errorMsg,
            errors: response["errors"],
          ),
        );
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

    // مسح كل البيانات المتعلقة بالمستخدم
    await prefs.remove("token");
    await prefs.remove("id");
    await prefs.remove("first_name");
    await prefs.remove("last_name");
    await prefs.remove("phone");
    await prefs.remove("role");
    await prefs.remove("date_of_birth");

    print("🟢 User logged out successfully (local data cleared)");
  }
}
