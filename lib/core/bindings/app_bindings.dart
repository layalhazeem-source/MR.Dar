import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../api/dio_consumer.dart';
import '../../controller/logincontroller.dart';
import '../../controller/signupcontroller.dart';
import '../../service/auth_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // 1) Dio instance
    Get.lazyPut<Dio>(() => Dio());

    // 2) DioConsumer
    Get.lazyPut<DioConsumer>(() => DioConsumer(dio: Get.find<Dio>()));

    // 3) AuthService
    Get.lazyPut<AuthService>(() => AuthService(api: Get.find<DioConsumer>()));

    // 4) Controllers
    Get.lazyPut<LoginController>(
      () => LoginController(api: Get.find<AuthService>()),
    );

    Get.lazyPut<SignupController>(
      () => SignupController(api: Get.find<AuthService>()),
    );
  }
}
