import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class loginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  bool validateLogin() {
    if (formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }
  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
