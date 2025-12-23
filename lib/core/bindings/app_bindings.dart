import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../controller/ApartmentController.dart';
import '../../controller/FilterController.dart';
import '../../controller/UserController.dart';
import '../../controller/add_apartment_controller.dart';
import '../../controller/authcontroller.dart';
import '../../controller/edit_profile_controller.dart';
import '../../controller/homecontroller.dart';
import '../../controller/my_account_controller.dart';
import '../../service/ApartmentService.dart';
import '../../service/UserLocalService.dart';
import '../../service/userService.dart';
import '../api/dio_consumer.dart';
import '../../controller/logincontroller.dart';
import '../../controller/signupcontroller.dart';
import '../../service/auth_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    final dio = Dio();

    // 1. Register Dio and DioConsumer (مرة واحدة فقط)
    Get.put<Dio>(dio, permanent: true);
    final dioConsumer = DioConsumer(dio: dio);
    Get.put<DioConsumer>(dioConsumer, permanent: true);

    // 2. Register Services (مرة واحدة فقط)
    final authService = AuthService(api: dioConsumer);
    Get.put<AuthService>(authService, permanent: true);

    final apartmentService = ApartmentService(api: dioConsumer);
    Get.put<ApartmentService>(apartmentService, permanent: true);

    final userService = UserService(dioConsumer); // ✅ تمرير الـ api
    Get.put<UserService>(userService, permanent: true);

    Get.put<UserLocalService>(UserLocalService(), permanent: true);

    // 3. Register Controllers
    Get.put<HomeController>(HomeController(), permanent: true);

    Get.lazyPut<LoginController>(
      () => LoginController(api: authService),
      fenix: true,
    );

    Get.lazyPut<SignupController>(
      () => SignupController(api: authService),
      fenix: true,
    );

    Get.put<AuthController>(
      AuthController(authService: authService),
      permanent: true,
    );

    Get.lazyPut<UserController>(() {
      final controller = UserController();
      controller.loadUserRole();
      return controller;
    }, fenix: true);

    Get.lazyPut<ApartmentController>(
      () => ApartmentController(service: apartmentService),
      fenix: true,
    );
    Get.lazyPut<AddApartmentController>(
          () => AddApartmentController(
        service: Get.find<ApartmentService>(),
      ),
      fenix: true,
    );


    // ✅ تأكد من أن MyAccountController يحتوي على constructor يأخذ userService
    Get.lazyPut<MyAccountController>(
      () => MyAccountController(service: userService), // ✅ تأكد من اسم المعلمة
      fenix: true,
    );
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(
        userService: Get.find<UserService>(),
        myAccountController: Get.find<MyAccountController>(),
      ),
      fenix: true,
    );
    // 4. Register FilterController (مرة واحدة فقط)
    Get.lazyPut<FilterController>(() => FilterController(), fenix: true);
  }
}
