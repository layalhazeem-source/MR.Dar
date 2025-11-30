import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(backgroundColor: const Color(0xFFE8E8E8), elevation: 0),

      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            padding: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
            color: Color(0xFFE8E8E8),

            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 275,
                    child: Image.asset("images/photo_2025-11-27_11-23-04.jpg"),
                  ),

                  Center(
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff074067),
                      ),
                    ),
                  ),

                  SizedBox(height: 35.h),

                  TextFormField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    style: const TextStyle(color: Colors.black87, fontSize: 22),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is required!";
                      }
                      if (value.length != 10) {
                        return "Phone number must be 10 numbers!";
                      }
                      return null;
                    },

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
                    ),
                  ),

                  SizedBox(height: 15.h),

                  GetBuilder<loginController>(
                    builder: (controller) {
                      return TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden,
                        maxLength: 15,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required!";
                          }
                          if (value.length < 7) {
                            return "Password must be at least 7 characters!";
                          }

                          return null;
                        },

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
                                  ? Icons.lock
                                  : Icons.lock_open,
                              color: Colors.black45,
                              size: 30,
                            ),
                            onPressed: () => controller.togglePassword(),
                          ),
                          fillColor: Color(0xFFCFFDFA),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(
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
                        if (controller.validateLogin()) {
                          Get.to(Home());
                        }
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

                  SizedBox(height: 20.h),

                  // Signup link
                  Row(
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
                        onTap: () => Get.to(Signup()),
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

                  SizedBox(height: 20.h),

                  // Guest option
                  Row(
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
                        onTap: () => Get.to(Home()),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
