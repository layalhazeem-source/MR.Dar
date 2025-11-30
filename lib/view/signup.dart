import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/signupcontroller.dart';
import 'home.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  final signupController controller = Get.put(signupController());

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
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: const Color(0xFFE8E8E8),

            child: Form(
              key: controller.formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 130,
                      margin: EdgeInsets.only(top: 0),
                      child: Image.asset(
                        "images/photo_2025-11-27_11-23-04.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 9.h),

                  GetBuilder<signupController>(
                    builder: (ctrl) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Renter
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3, // حجم الراديو
                                child: Radio<String>(
                                  value: "renter",
                                  groupValue: ctrl.userType.value,
                                  onChanged: (value) =>
                                      ctrl.setUserType(value!),
                                  activeColor: Color(
                                    0xFF08D9CE,
                                  ), // نفس لون التطبيق
                                ),
                              ),
                              Text(
                                "Renter",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 25),

                          // Owner
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String>(
                                  value: "owner",
                                  groupValue: ctrl.userType.value,
                                  onChanged: (value) =>
                                      ctrl.setUserType(value!),
                                  activeColor: Color(0xFF08D9CE),
                                ),
                              ),
                              Text(
                                "Owner",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 15.h),

                  /// First & Last Name
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.firstNameController,
                          maxLength: 20,
                          style: const TextStyle(
                            color: Colors.black87,
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

                      SizedBox(width: 10),

                      Expanded(
                        child: TextFormField(
                          controller: controller.lastNameController,
                          maxLength: 20,
                          style: const TextStyle(
                            color: Colors.black87,
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

                  GetBuilder<signupController>(
                    builder: (ctrl) {
                      return TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: ctrl.birthDate.value,
                        ),
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
                            ctrl.setBirthDate(
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}",
                            );
                          }
                        },
                        validator: (value) => ctrl.birthDate.value.isEmpty
                            ? "Date of Birth is required!"
                            : null,
                      );
                    },
                  ),

                  SizedBox(height: 15.h),
                  GetBuilder<signupController>(
                    builder: (ctrl) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => ctrl.selectProfileImage(),
                            child: AbsorbPointer(
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: ctrl.profileImage.value?.name ?? "",
                                ),
                                decoration: InputDecoration(
                                  labelText: "Profile Image",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  suffixIcon: const Icon(
                                    Icons.upload_file,
                                    size: 28,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFCFFDFA),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.black26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 15.h),

                          GestureDetector(
                            onTap: () => ctrl.pickIdImage(),
                            child: AbsorbPointer(
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: ctrl.idImage.value?.name ?? "",
                                ),
                                decoration: InputDecoration(
                                  labelText: "ID Image",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  suffixIcon: const Icon(
                                    Icons.upload_file,
                                    size: 28,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFCFFDFA),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.black26,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 10.h),

                  /// Phone
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
                    decoration: _inputDecoration("Phone", suffix: Icons.phone),
                  ),

                  SizedBox(height: 10.h),

                  /// Password
                  GetBuilder<signupController>(
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
                              controller.isPasswordHidden
                                  ? Icons.lock
                                  : Icons.lock_open,
                              color: Colors.black45,
                              size: 30,
                            ),
                            onPressed: () => controller.togglePassword(),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),

                  /// Password
                  SizedBox(height: 10),

                  GetBuilder<signupController>(
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

                  SizedBox(height: 10.h),

                  /// Button
                  SizedBox(
                    height: 55.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF08D9CE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                      onPressed: () {
                        if (controller.validateSignup()) {
                          Get.to(Home());
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),
                ],
              ),
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
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black45,
        fontSize: 18,
      ),

      // هون الأهم ↓↓↓
      suffixIcon:
          suffixWidget ??
          (suffix != null
              ? Icon(suffix, color: Colors.black45, size: 28)
              : null),

      fillColor: const Color(0xFFCFFDFA),
      filled: true,
      border: const OutlineInputBorder(),
    );
  }
}
