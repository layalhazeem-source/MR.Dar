import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_project/view/onboarding/onboarding_screen.dart';
import 'fcm_test.dart';
import 'view/apartment_details_page.dart';
import 'core/bindings/app_bindings.dart';
import 'view/Splash.dart';
import 'view/WelcomePage.dart';
import 'view/home.dart';
import 'view/login.dart';
import 'view/signup.dart';
import 'package:get_storage/get_storage.dart';
import 'core/theme/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // لازم قبل استخدام GetStorage

  final storage = GetStorage();
  final themeService = ThemeService(storage);

  // نخزّن الخدمة كـ singleton
  Get.put<ThemeService>(themeService, permanent: true);

  // نطبق الثيم اللي مخزون
  Get.changeThemeMode(themeService.themeMode);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initFcm(); // 👈 هون

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: AppBindings(),
          debugShowCheckedModeBanner: false,
          theme: themeService.lightTheme,
          darkTheme: themeService.darkTheme,
          themeMode: themeService.themeMode,
          home: Splash(),
          getPages: [
            GetPage(name: "/home", page: () => Home()),
            GetPage(name: "/signup", page: () => Signup()),
            GetPage(name: "/login", page: () => Login()),
            GetPage(name: "/welcome", page: () => WelcomePage()),
            // ✅ أضف هذه الصفحة
            GetPage(
              name: "/apartmentDetails",
              page: () {
                final apartment = Get.arguments;
                return ApartmentDetailsPage(apartment: apartment);
              },
            ),
            GetPage(name: "/onboarding", page: () => OnboardingScreen()),
          ],
        );
      },
    );
  }
}
