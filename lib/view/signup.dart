import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/signupcontroller.dart';
import '../service/auth_service.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  final SignupController controller = Get.put(
    SignupController(api: Get.find<AuthService>()),
  );

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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        "Join us and find your perfect home",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF274668),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // اختيار نوع المستخدم
                      GetBuilder<SignupController>(
                        builder: (ctrl) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.3,
                                    child: Radio<int>(
                                      value: 2, // Renter
                                      groupValue: ctrl.role.value,
                                      onChanged: (value) =>
                                          ctrl.setRole(value!),
                                      activeColor: Color(0xFF74B4DA),
                                    ),
                                  ),
                                  Text(
                                    "Renter",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF274668),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.3,
                                    child: Radio<int>(
                                      value: 3,
                                      groupValue: ctrl.role.value,
                                      onChanged: (value) =>
                                          ctrl.setRole(value!),
                                      activeColor: Color(0xFF74B4DA),
                                    ),
                                  ),
                                  Text(
                                    "Owner",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF274668),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 15.h),

                      // First & Last Name
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.firstNameController,
                              maxLength: 20,
                              style: const TextStyle(
                                color: Color(0xFF274668),
                                fontSize: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "First name is required!";
                                }
                                return null;
                              },
                              decoration: _inputDecoration("First name"),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: TextFormField(
                              controller: controller.lastNameController,
                              maxLength: 20,
                              style: const TextStyle(
                                color: Color(0xFF274668),
                                fontSize: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Last name is required!";
                                }
                                return null;
                              },
                              decoration: _inputDecoration("Last name"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),

                      // Date of Birth
                      GetBuilder<SignupController>(
                        builder: (ctrl) {
                          return TextFormField(
                            readOnly: true,
                            controller: ctrl.birthDateController,
                            decoration: _inputDecoration(
                              "Date of Birth",
                              suffix: Icons.calendar_today,
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2000),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                // هون حطي السطر:
                                ctrl.setBirthDate(
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}",
                                );
                              }
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? "Date of Birth is required!"
                                : null,
                          );
                        },
                      ),
                      SizedBox(height: 15.h),

                      // Profile Image & ID Image
                      GetBuilder<SignupController>(
                        builder: (ctrl) {
                          return Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => ctrl.selectProfileImage(),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration: _inputDecoration(
                                        "Profile Image",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => ctrl.pickIdImage(),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration: _inputDecoration("ID Image"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 15.h),

                      // Phone
                      TextFormField(
                        controller: controller.phoneController,
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
                        ),
                      ),
                      SizedBox(height: 15.h),

                      // Password
                      GetBuilder<SignupController>(
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
                              if (value.length < 8) {
                                return "Password must be at least 8 characters!";
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
                                  size: 30,
                                ),
                                onPressed: () => ctrl.togglePassword(),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15.h),

                      // Confirm Password
                      GetBuilder<SignupController>(
                        builder: (ctrl) {
                          return TextFormField(
                            controller: ctrl.confirmPasswordController,
                            obscureText: ctrl.isConfirmHidden,
                            maxLength: 15,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirm password is required!";
                              }
                              if (value != ctrl.passwordController.text) {
                                return "Passwords do not match!";
                              }
                              return null;
                            },
                            decoration: _inputDecoration(
                              "Confirm Password",
                              suffixWidget: IconButton(
                                icon: Icon(
                                  ctrl.isConfirmHidden
                                      ? Icons.lock
                                      : Icons.lock_open,
                                  color: Colors.black54,
                                  size: 28,
                                ),
                                onPressed: () => ctrl.toggleConfirmPassword(),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15.h),

                      // Sign Up Button
                      GetBuilder<SignupController>(
                        builder: (ctrl) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: ctrl.isLoading
                                  ? null
                                  : () => controller.signupUser(),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                backgroundColor: Color(0xFF274668),
                                elevation: 3,
                              ),
                              child: ctrl.isLoading
                                  ? SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 15.h),
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
