import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../controller/ApartmentController.dart';
import '../../controller/FilterController.dart';
import '../../controller/UserController.dart';
import '../../controller/add_apartment_controller.dart';
import '../../controller/authcontroller.dart';
import '../../controller/edit_profile_controller.dart';
import '../../controller/homecontroller.dart';
import '../../controller/locale/locale_controller.dart';
import '../../controller/my_account_controller.dart';
import '../../controller/my_apartments_controller.dart';
import '../../controller/my_rents_controller.dart';
import '../../service/ApartmentService.dart';
import '../../service/UserLocalService.dart';
import '../../service/booking_service.dart';
import '../../service/userService.dart';
import '../api/dio_consumer.dart';
import '../../controller/logincontroller.dart';
import '../../controller/signupcontroller.dart';
import '../../service/auth_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    final dio = Dio();
    final dioConsumer = DioConsumer(dio: dio);
    final authService = AuthService(api: dioConsumer);
    final apartmentService = ApartmentService(api: dioConsumer);
    final userService = UserService(dioConsumer);
    final controller = UserController();
    final bookingService = BookingService(api: dioConsumer);

    //core
    Get.put<Dio>(dio, permanent: true);
    Get.put<DioConsumer>(dioConsumer, permanent: true);

    //Services
    Get.put<AuthService>(authService, permanent: true);
    Get.put<ApartmentService>(apartmentService, permanent: true);
    Get.put<UserService>(UserService(dioConsumer), permanent: true);
    Get.put<UserLocalService>(UserLocalService(), permanent: true);
    Get.put<BookingService>(bookingService, permanent: true);

    //Controllers
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<ApartmentController>(
      ApartmentController(service: Get.find()),
      permanent: true,
    );
    Get.put<AuthController>(
      AuthController(authService: authService, userService: userService),
      permanent: true,
    );

    Get.put(LocaleController(), permanent: true);

    //lazy Controllers
    Get.lazyPut<MyAccountController>(
      () => MyAccountController(service: userService),
      fenix: true,
    );

    Get.lazyPut<EditProfileController>(
      () => EditProfileController(
        userService: Get.find<UserService>(),
        myAccountController: Get.find<MyAccountController>(),
      ),
      fenix: true,
    );

    Get.lazyPut<LoginController>(
      () => LoginController(api: authService),
      fenix: true,
    );

    Get.lazyPut<SignupController>(
      () => SignupController(api: authService),
      fenix: true,
    );

    Get.lazyPut<UserController>(() {
      controller.loadUserRole();
      return controller;
    }, fenix: true);

    Get.lazyPut<ApartmentController>(
      () => ApartmentController(service: apartmentService),
      fenix: true,
    );

    Get.lazyPut<AddApartmentController>(
      () => AddApartmentController(service: Get.find<ApartmentService>()),
      fenix: true,
    );

    Get.lazyPut<FilterController>(() => FilterController(), fenix: true);

    Get.put<MyRentsController>(
      MyRentsController(bookingService: Get.find()),
      permanent: true,
    );
    Get.lazyPut<MyApartmentsController>(
          () => MyApartmentsController(apartmentService: Get.find<ApartmentService>()),
      fenix: true,
    );


  }
}
