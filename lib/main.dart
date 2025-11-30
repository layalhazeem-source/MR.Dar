import 'package:flutter/material.dart';
import 'package:new_project/view/WelcomePage.dart';
import 'package:new_project/view/home.dart';
import 'package:get/get.dart';
import 'package:new_project/view/home.dart';
import 'package:new_project/view/login.dart';
import 'package:new_project/view/signup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          debugShowCheckedModeBanner: false,
          home: WelcomePage(),
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
