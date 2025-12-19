import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../controller/ApartmentController.dart';
import '../../controller/UserController.dart';
import '../../controller/authcontroller.dart';
import '../../controller/homecontroller.dart';
import '../../controller/my_account_controller.dart';
import '../../service/ApartmentService.dart';
import '../../service/userService.dart';
import '../api/dio_consumer.dart';
import '../../controller/logincontroller.dart';
import '../../controller/signupcontroller.dart';
import '../../service/auth_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    final dio = Dio();

    Get.put<Dio>(Dio(), permanent: true);

    Get.put<DioConsumer>(DioConsumer(dio: Get.find<Dio>()), permanent: true);

    Get.put<AuthService>(
      AuthService(api: Get.find<DioConsumer>()),
      permanent: true,
    );
    Get.put<ApartmentService>(
      ApartmentService(api: Get.find<DioConsumer>()),
      permanent: true,
    );
    Get.put<UserService>(UserService(Get.find()), permanent: true);

    // Controllers
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<LoginController>(
      () => LoginController(api: Get.find<AuthService>()),
    );
    Get.lazyPut<SignupController>(
      () => SignupController(api: Get.find<AuthService>()),
    );
    Get.put<AuthController>(
      AuthController(authService: Get.find<AuthService>()),
      permanent: true,
    );
    Get.lazyPut<UserController>(() {
      final controller = UserController();
      controller.loadUserRole(); // ⬅️ هون نستدعيها
      return controller;
    }, fenix: true);

    Get.put<ApartmentController>(
      ApartmentController(service: Get.find<ApartmentService>()),
    );
    Get.put<MyAccountController>(
      MyAccountController(Get.find()),
      permanent: true,
    );
  }
}
