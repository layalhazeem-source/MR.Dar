import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';

class LoginController extends GetxController {
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();
  final AuthService api;
  LoginController({required this.api});

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordHidden = true;
  String? phoneError;
  String? passError;

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  Future<void> loginUser() async {
    phoneError = null;
    passError = null;
    update();

    if (!formKey.currentState!.validate()) return;
    isLoading = true;
    update();
    try {
      final token = await api.login(
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();
      final int? role = prefs.getInt("role");

      isLoading = false;
      update();

      if (role == 1) {
        Get.defaultDialog(
          title: "Admin Account",
          middleText: "Welcome Admin.\nAdmin panel is under development.",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back(); // يسكر الديالوج
          },
        );
        return; // 🔴 مهم جدًا حتى ما يكمل
      }

// غير الأدمن
      Get.offAll(() => Home());

    } on ServerException catch (e) {
      isLoading = false;
      phoneError = e.errModel.errorMessage;
      passError = e.errModel.errorMessage;
      update();

      Get.snackbar(
        "Error",
        e.errModel.errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      isLoading = false;
      update();
      Get.defaultDialog(
        title: "Admin Account",
        middleText: "Welcome Admin.\nAdmin panel is under development.",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back(); // يسكر الديالوج
        },
      );

    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
