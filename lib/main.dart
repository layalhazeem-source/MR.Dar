import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/bindings/app_bindings.dart';
import 'view/Splash.dart';
import 'view/WelcomePage.dart';
import 'view/home.dart';
import 'view/login.dart';
import 'view/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: AppBindings(),   // 🔥 أهم سطر — تشغيل الـ Bindings
          debugShowCheckedModeBanner: false,
          home: Splash(),                 // شاشة البداية
          getPages: [
            GetPage(name: "/home", page: () => Home()),
            GetPage(name: "/signup", page: () => Signup()),
            GetPage(name: "/login", page: () => Login()),
            GetPage(name: "/welcome", page: () => WelcomePage()),
          ],
        );
      },
    );
  }
}
