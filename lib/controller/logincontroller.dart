import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/core/api/dio_consumer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';
import 'homecontroller.dart';
import 'my_account_controller.dart';

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
    isLoading = true;
    update();
    try {
      final token = await api.login(
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("✅ Login successful, token: $token");

      isLoading = false;
      update();

      Get.offAll(() => Home());
    } on ServerException catch (e) {
      isLoading = false;
      phoneError = e.errModel?.errorMessage;
      passError = e.errModel?.errorMessage;
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

      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
