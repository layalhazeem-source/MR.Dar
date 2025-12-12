import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../controller/ApartmentController.dart';
import '../../controller/authcontroller.dart';
import '../../controller/homecontroller.dart';
import '../../controller/my_account_controller.dart';
import '../../service/ApartmentService.dart';
import '../api/dio_consumer.dart';
import '../../controller/logincontroller.dart';
import '../../controller/signupcontroller.dart';
import '../../service/auth_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    final dio = Dio();

    // Dio يبقى دائم
    Get.put<Dio>(Dio(), permanent: true);

    // DioConsumer يبقى دائم
    Get.put<DioConsumer>(DioConsumer(dio: Get.find<Dio>()), permanent: true);

    // AuthService يبقى دائم
    Get.put<AuthService>(
      AuthService(api: Get.find<DioConsumer>()),
      permanent: true,
    );
    Get.put<ApartmentService>(
      ApartmentService(api: Get.find<DioConsumer>()),
      permanent: true,
    );

    // Controllers
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<MyAccountController>(() => MyAccountController());
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
    Get.put<ApartmentController>(
      ApartmentController(service: Get.find<ApartmentService>()),
    );
    Get.put<MyAccountController>(MyAccountController(), permanent: true);
  }
}
