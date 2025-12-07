import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/core/api/dio_consumer.dart';
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

  @override
  void onInit() {
    super.onInit();
  }

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  Future<void> loginUser() async {
    phoneError = null;
    passError = null;
    update();

    if (!formKey.currentState!.validate()) return;
    isLoading = true;   // ⬅️ بدء التحميل
    update();
    try {
      final token = await api.login(
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );
      // حفظ التوكن
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      isLoading = false; // ⬅️ ايقاف التحميل
      update();

      Get.offAll(() => Home());
    } on ServerException catch (e) {
      isLoading = false; // ⬅️ ايقاف التحميل عند الخطأ
      phoneError = e.errModel?.errorMessage;
      passError = e.errModel?.errorMessage;
      update();
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
