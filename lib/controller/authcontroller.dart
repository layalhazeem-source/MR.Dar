import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fcm_test.dart';
import '../service/auth_service.dart';
import '../controller/my_account_controller.dart';
import '../service/userService.dart';
import '../view/WelcomePage.dart';
import '../view/home.dart';

class AuthController extends GetxController {
  final AuthService authService;
  final UserService userService;

  AuthController({required this.authService, required this.userService});

  /// بعد Login أو Signup
  Future<void> handleAuthSuccess() async {
    await Get.find<MyAccountController>().loadProfile();
    await initFcm();

    Get.offAll(() => Home());
  }

  Future<void> logout() async {
    try {
      print('🔐 Starting logout process...');

      // 1️⃣ نرسل طلب logout للـ API أولاً
      try {
        await userService.logout();
        print('✅ Server logout successful');
      } catch (e) {
        print('⚠️ Server logout failed: $e');
        // نكمل حتى لو فشل السيرفر
      }

      // 2️⃣ نمسح البيانات المحلية
      await authService.signOut();
      print('✅ Local data cleared');

      // 3️⃣ نظهر رسالة نجاح
      Get.snackbar(
        "Logged Out",
        "You have been logged out successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // 4️⃣ ننتقل لصفحة الترحيب
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(() => const WelcomePage());
    } catch (e) {
      print('🔴 Logout error: $e');
      Get.snackbar(
        "Error",
        "Failed to logout: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // دالة للتأكد من حالة تسجيل الدخول
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
