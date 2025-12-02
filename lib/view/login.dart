import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/logincontroller.dart';
import 'home.dart';
import 'signup.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF96C6E2), elevation: 0),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Image.asset("images/wallpaper.png", fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          "images/logo1.png",
                          height: 200.h,
                          width: 200.w,
                        ),
                      ),
                      Center(
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF274668),
                          ),
                        ),
                      ),
                      SizedBox(height: 35.h),

                      // Phone
                      GetBuilder<LoginController>(
                        builder: (ctrl) {
                          return TextFormField(
                            controller: ctrl.phoneController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Phone number is required!";
                              }
                              if (value.length != 10) {
                                return "Phone number must be 10 numbers!";
                              }
                              return null;
                            },
                            decoration: _inputDecoration(
                              "Phone",
                              suffix: Icons.phone,
                            ).copyWith(errorText: ctrl.phoneError),
                          );
                        },
                      ),

                      SizedBox(height: 15.h),

                      // Password
                      GetBuilder<LoginController>(
                        builder: (ctrl) {
                          return TextFormField(
                            controller: ctrl.passwordController,
                            obscureText: ctrl.isPasswordHidden,
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
                            decoration: _inputDecoration(
                              "Password",
                              suffixWidget: IconButton(
                                icon: Icon(
                                  ctrl.isPasswordHidden
                                      ? Icons.lock
                                      : Icons.lock_open,
                                  color: Colors.black45,
                                  size: 28,
                                ),
                                onPressed: () => ctrl.togglePassword(),
                              ),
                            ).copyWith(errorText: ctrl.passError),
                          );
                        },
                      ),

                      SizedBox(height: 20.h),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF274668),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 3,
                          ),
                          onPressed: () {
                            controller.loginUser();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Log In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 25.h),

                      // Signup link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don’t have an account? ",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(Signup()),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color(0xFF274668),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      // Guest option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Or continue as a ",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(Home()),
                            child: const Text(
                              "Guest",
                              style: TextStyle(
                                color: Color(0xFF274668),
                                fontSize: 18,
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
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label, {
    IconData? suffix,
    Widget? suffixWidget,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black45,
        fontSize: 18,
      ),
      suffixIcon:
          suffixWidget ??
          (suffix != null
              ? Icon(suffix, color: Colors.black45, size: 28)
              : null),
      fillColor: const Color(0xFFDFEEF6),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF274668), width: 2),
      ),
    );
  }
}
