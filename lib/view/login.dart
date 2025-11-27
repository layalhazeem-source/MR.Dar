import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:new_project/view/home.dart';
import 'package:new_project/view/signup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/logincontroller.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final loginController controller = Get.put(loginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 70, left: 20, right: 20),
        color: Color(0xFFE8E8E8),
        child: Column(
          children: [
            Container(
              height: 275,
              child: Image.asset("images/photo_2025-11-27_11-23-04.jpg"),
            ),

            Center(
              child: Text(
                "Welcome Back ",
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff074067),
                ),
              ),
            ),

            SizedBox(height: 35.h),
            Container(
              child: Form(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: const TextStyle(color: Colors.black87, fontSize: 22),
                  decoration: InputDecoration(
                    labelText: "Phone",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 20,
                    ),

                    suffixIcon: Icon(
                      Icons.phone,
                      color: Colors.black45,
                      size: 30,
                    ),
                    fillColor: Color(0xFFCFFDFA),
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF34F6F2),
                        width: 2.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26, width: 2.w),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 15.h),
            GetBuilder<loginController>(
              builder: (controller) {
                return TextFormField(
                  obscureText: controller.isPasswordHidden,
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  style: const TextStyle(color: Colors.black87, fontSize: 22),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 20,
                    ),

                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden
                            ? Icons
                                  .lock // مغلق
                            : Icons.lock_open, // ظاهر
                        color: Colors.black45,
                        size: 30,
                      ),
                      onPressed: () {
                        controller.togglePassword(); // استدعاء الفنكشن
                      },
                    ),

                    fillColor: Color(0xFFCFFDFA),
                    filled: true,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF34F6F2),
                        width: 2.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26, width: 2.w),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF08D9CE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),

                  onPressed: () {
                    Get.to(Home());
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(Signup());
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF08D9CE),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Or continue as a ",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(Signup());
                    },
                    child: Text(
                      "Guest",
                      style: TextStyle(
                        color: Color(0xFF08D9CE),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
