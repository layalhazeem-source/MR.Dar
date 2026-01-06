import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/errors/exceptions.dart';
import '../fcm_test.dart';
import '../service/auth_service.dart';
import '../view/home.dart';
import 'UserController.dart';
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

      isLoading = false;
      update();
      final userCtrl = Get.put(UserController());
      await userCtrl.loadUserRole();
      if (userCtrl.isAdmin) {
        Get.defaultDialog(
          title: "Admin Account",
          middleText:
              "Admin dashboard is under development.\nPlease use a regular user account.",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          buttonColor: const Color(0xFF274668),
          onConfirm: () {
            Get.back();
            //clear
            phoneController.clear();
            passwordController.clear();
            update();
          },
          barrierDismissible: false,
        );
        return;
      }
      await initFcm(); // ← هون

      Get.offAll(
        () => Home(),
        binding: BindingsBuilder(() {
          Get.put(HomeController());
        }),
      );
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
