import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fcm_test.dart';
import '../service/auth_service.dart';
import '../controller/my_account_controller.dart';
import '../service/userService.dart';
import '../view/WelcomePage.dart';
import '../view/home.dart';
import '../view/onboarding/onboarding_screen.dart';
import 'ApartmentController.dart';
import 'UserController.dart';
import 'homecontroller.dart';
import 'notification_controller.dart';

class AuthController extends GetxController {
  final AuthService authService;
  final UserService userService;

  AuthController({required this.authService, required this.userService});

  /// After Login or Signup
  Future<void> handleAuthSuccess() async {
    await Get.find<MyAccountController>().loadProfile();
    await initFcm();

    Get.offAll(() => Home());
  }

  Future<void> logout() async {
    try {
      print('Starting logout process...');

      try {
        await userService.logout();
        print(' Server logout successful');
      } catch (e) {
        print(' Server logout failed: $e');
      }

      await authService.signOut();
      print('Local data cleared');

      Get.snackbar(
        "Logged Out",
        "You have been logged out successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      Get.delete<HomeController>();
      Get.delete<UserController>();
      Get.delete<ApartmentController>();
      Get.delete<NotificationController>();
      Get.offAll(() => const OnboardingScreen());
    } catch (e) {
      print(' Logout error: $e');
      Get.snackbar(
        "Error",
        "Failed to logout: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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
