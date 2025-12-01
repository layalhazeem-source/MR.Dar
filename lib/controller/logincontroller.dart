import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';

class loginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordHidden = true;

  late final AuthService authService;
  @override
  void onInit() {
    authService = AuthService(); // إنشاء instance من AuthService
    super.onInit();
  }

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  Future<void> loginUser() async {
    print("🔥 loginUser started");
    if (formKey.currentState!.validate()) {
      print("🔥 validation OK");
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();
      print("🔥 calling authService.login ...");
      try {
        await authService.login(phone: phone, password: password);
        print("🔥 login SUCCESS");
        Get.snackbar('Success', 'Logged in successfully!');

        Get.to(() => Home());
      } on SereverException catch (e) {
        print("🔥 login ERROR: ${e.errModel.errorMessage}");
        Get.snackbar('Error', e.errModel.errorMessage);
      }
    } else {
      print("❌ validation FAILED");
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
