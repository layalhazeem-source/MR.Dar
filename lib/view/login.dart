import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/logincontroller.dart';
import 'home.dart';
import 'signup.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: screenHeight,
            width: double.infinity,
            child: Image.asset(
              "images/photo_2025-11-30_12-36-36.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 15),
                        const Center(
                          child: Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF274668),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Phone Field
                        GetBuilder<LoginController>(
                          builder: (ctrl) {
                            return TextFormField(
                              controller: ctrl.phoneController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              style: const TextStyle(color: Colors.black87, fontSize: 18),
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Phone required!";
                                if (value.length != 10) return "Phone must be 10 digits!";
                                return null;
                              },
                              decoration: _inputDecoration("Phone", suffix: Icons.phone)
                                  .copyWith(errorText: ctrl.phoneError),
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        // Password Field
                        GetBuilder<LoginController>(
                          builder: (ctrl) {
                            return TextFormField(
                              controller: ctrl.passwordController,
                              obscureText: ctrl.isPasswordHidden,
                              maxLength: 15,
                              style: const TextStyle(color: Colors.black87, fontSize: 18),
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Password required!";
                                if (value.length < 7) return "Min 7 characters!";
                                return null;
                              },
                              decoration: _inputDecoration(
                                "Password",
                                suffixWidget: IconButton(
                                  icon: Icon(
                                    ctrl.isPasswordHidden ? Icons.lock : Icons.lock_open,
                                    color: Colors.black45,
                                  ),
                                  onPressed: ctrl.togglePassword,
                                ),
                              ).copyWith(errorText: ctrl.passError),
                            );
                          },
                        ),
                        const SizedBox(height: 25),

                        // Login Button
                        GetBuilder<LoginController>(
                          builder: (ctrl) {
                            return SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF274668),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: ctrl.isLoading ? null : controller.loginUser,
                                child: ctrl.isLoading
                                    ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Text(
                                  "Log In",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 15),

                        // Signup link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don’t have an account? ",
                                style: TextStyle(color: Colors.black54)),
                            GestureDetector(
                              onTap: () => Get.to(Signup()),
                              child: const Text("Sign Up",
                                  style: TextStyle(
                                      color: Color(0xFF274668),
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Guest link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Or continue as a ", style: TextStyle(color: Colors.black54)),
                            GestureDetector(
                              onTap: () => Get.to(Home()),
                              child: const Text("Guest",
                                  style: TextStyle(
                                      color: Color(0xFF274668),
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF274668),
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? suffix, Widget? suffixWidget}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
      suffixIcon: suffixWidget ?? (suffix != null ? Icon(suffix, color: Colors.black45) : null),
      filled: true,
      fillColor: const Color(0xFFDFEEF6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF274668), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.black26),
      ),
    );
  }
}
