import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:new_project/view/Splash.dart';
import 'core/api/dio_consumer.dart';
import 'controller/logincontroller.dart';
import 'controller/signupcontroller.dart';
import 'package:new_project/view/WelcomePage.dart';
import 'package:new_project/view/home.dart';
import 'package:new_project/view/login.dart';
import 'package:new_project/view/signup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/bindings/app_bindings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 base size
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: AppBindings(), // ← استدعاء الـ Bindings
          debugShowCheckedModeBanner: false,
          home: Splash(),
          getPages: [
            GetPage(name: "/home", page: () => Home()),
            GetPage(name: "/signup", page: () => Signup()),
            GetPage(name: "/api/login", page: () => Login()),
            GetPage(name: "/welcome", page: () => WelcomePage()),
          ],
        );
      },
    );
  }
}
