import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/core/api/dio_consumer.dart';
import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';

class LoginController extends GetxController {
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

    try {
      await api.login(
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      phoneError = null;
      passError = null;
      update();

      Get.to(() => Home());
    } on ServerException catch (e) {
      phoneError = e.errModel?.errorMessage ?? "Invalid Credentials";
      passError = e.errModel?.errorMessage ?? "Invalid Credentials";
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
