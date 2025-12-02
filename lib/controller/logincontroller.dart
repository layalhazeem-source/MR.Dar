import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordHidden = true;

  String? phoneError;
  String? passError;

  late final AuthService authService;

  @override
  void onInit() {
    authService = AuthService();
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

    if (formKey.currentState!.validate()) {
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      try {
        await authService.login(phone: phone, password: password);

        Get.snackbar('Success', 'Logged in successfully!');
        Get.to(() => Home());
      } on SereverException catch (e) {
        // سواء الرقم غلط أو الباسوورد غلط، نفس الرسالة تحت الاثنين
        phoneError = passError = e.errModel.errorMessage;
        update();
      }
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
