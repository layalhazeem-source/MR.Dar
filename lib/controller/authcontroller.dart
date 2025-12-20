import 'package:get/get.dart';
import '../service/auth_service.dart';
import '../controller/my_account_controller.dart';
import '../view/WelcomePage.dart';
import '../view/home.dart';

class AuthController extends GetxController {
  final AuthService authService;

  AuthController({required this.authService});

  /// بعد Login أو Signup
  Future<void> handleAuthSuccess() async {
    // جيبي بيانات اليوزر
    await Get.find<MyAccountController>().loadProfile();

    // روحي عالـ Home
    Get.offAll(() => Home());
  }

  Future<void> logout() async {
    await authService.signOut();
    Get.offAll(() => const WelcomePage());
  }
}
