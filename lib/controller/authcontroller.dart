import 'package:get/get.dart';
import '../service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/WelcomePage.dart';

class AuthController extends GetxController {
  final AuthService authService;

  AuthController({required this.authService});

  Future<void> logout() async {
    await authService.signOut();

    // بعد حذف البيانات نوجّه المستخدم على صفحة تسجيل الدخول
    Get.offAll(() => const WelcomePage());
  }
}
