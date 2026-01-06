import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/logincontroller.dart';
import '../service/auth_service.dart';
import 'home.dart';
import 'signup.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final LoginController controller = Get.put(
    LoginController(api: Get.find<AuthService>()),
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              children: [
                const SizedBox(height: 40),

                SizedBox(
                  height: 250,
                  width: 320,

                  child: Image.asset(
                    "images/ChatGPT Image Jan 6, 2026, 09_51_23 PM.png",
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "Welcome Back".tr,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30),

                        // PHONE FIELD
                        GetBuilder<LoginController>(
                          builder: (ctrl) {
                            return TextFormField(
                              controller: ctrl.phoneController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Phone required!".tr;
                                }
                                if (value.length != 10) {
                                  return "Must be 10 digits".tr;
                                }
                                return null;
                              },
                              decoration: _inputDecoration(
                                context,
                                "Phone Number".tr,
                                suffix: Icons.phone,
                              ).copyWith(errorText: ctrl.phoneError),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        // PASSWORD FIELD
                        GetBuilder<LoginController>(
                          builder: (ctrl) {
                            return TextFormField(
                              controller: ctrl.passwordController,
                              obscureText: ctrl.isPasswordHidden,
                              maxLength: 15,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password required!".tr;
                                }
                                if (value.length < 8) {
                                  return "Min 8 characters!".tr;
                                }
                                return null;
                              },
                              decoration: _inputDecoration(
                                context,
                                "Password".tr,
                                suffixWidget: IconButton(
                                  icon: Icon(
                                    ctrl.isPasswordHidden
                                        ? Icons.lock
                                        : Icons.lock_open,
                                    color: Colors.black54,
                                  ),
                                  onPressed: ctrl.togglePassword,
                                ),
                              ).copyWith(errorText: ctrl.passError),
                            );
                          },
                        ),

                        const SizedBox(height: 30),

                        // LOGIN BUTTON
                        GetBuilder<LoginController>(
                          builder: (ctrl) {
                            return SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: ctrl.isLoading
                                    ? null
                                    : controller.loginUser,
                                child: ctrl.isLoading
                                    ? const SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Text(
                                        "Log In".tr,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 20,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 15),

                        // SIGNUP LINK
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don’t have an account?".tr),
                            GestureDetector(
                              onTap: () => Get.to(Signup()),
                              child: Text(
                                "Sign Up".tr,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // GUEST LINK
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     const Text("Continue as "),
                        //     GestureDetector(
                        //       onTap: () => Get.to(Home()),
                        //       child: const Text(
                        //         "Guest",
                        //         style: TextStyle(
                        //           color: Color(0xFF274668),
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String label, {
    IconData? suffix,
    Widget? suffixWidget,
  }) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        fontWeight: FontWeight.bold,
      ),
      suffixIcon:
          suffixWidget ??
          (suffix != null ? Icon(suffix, color: Colors.black45) : null),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          width: 1.5,
        ),
      ),
    );
  }
}
