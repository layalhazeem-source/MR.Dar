
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: Column(
              children: [
                const SizedBox(height: 40),

                /// ---------------------------
                ///           LOGO
                /// ---------------------------
                SizedBox(
                  height: 220,
                  width: 120,

                  child: Image.asset("images/logo1.png", fit: BoxFit.cover),
                ),

                const SizedBox(height: 30),

                /// ---------------------------
                ///      Welcome Text
                /// ---------------------------
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF274668),
                  ),
                ),

                const SizedBox(height: 10),

                /// ---------------------------
                ///     Centered Form
                /// ---------------------------
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
                                  return "Phone required!";
                                }
                                if (value.length != 10) {
                                  return "Phone must be 10 digits!";
                                }
                                return null;
                              },
                              decoration: _inputDecoration(
                                "Phone Number",
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
                                  return "Password required!";
                                }
                                if (value.length < 7) {
                                  return "Min 7 characters!";
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
                                  backgroundColor: const Color(0xFF274668),
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
                                    : const Text(
                                  "Log In",
                                  style: TextStyle(
                                    color: Colors.white,
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
                            const Text("Don’t have an account? "),
                            GestureDetector(
                              onTap: () => Get.to(Signup()),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Color(0xFF274668),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // GUEST LINK
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Continue as "),
                            GestureDetector(
                              onTap: () => Get.to(Home()),
                              child: const Text(
                                "Guest",
                                style: TextStyle(
                                  color: Color(0xFF274668),
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
              ],
            ),
          ),
        ),
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
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
      ),
      suffixIcon:
      suffixWidget ??
          (suffix != null ? Icon(suffix, color: Colors.black45) : null),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF274668), width: 3),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
    );
  }
}
