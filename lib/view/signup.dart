
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Join us & find your perfect home",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Color(0xFF274668),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF274668)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),

                // اختيار النوع
                GetBuilder<SignupController>(
                  builder: (ctrl) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                    onTap: () => ctrl.setRole('renter'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: ctrl.role.value == 'renter'
                                    ? const Color(0xFF274668)
                                    : const Color(0xFFE8ECF4),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Renter",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ctrl.role.value == 'renter'
                                        ? Colors.white
                                        : const Color(0xFF274668),

                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                    onTap: () => ctrl.setRole('owner'),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: ctrl.role.value == 'owner'
                                    ? const Color(0xFF274668)
                                    : const Color(0xFFE8ECF4),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Owner",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ctrl.role.value == 'owner'
                                        ? Colors.white
                                        : const Color(0xFF274668),
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

                SizedBox(height: 20.h),

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
                        validator: (v) =>
                        v!.isEmpty ? "First name is required!" : null,
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
                        validator: (v) =>
                        v!.isEmpty ? "Last name is required!" : null,
                        decoration: _inputDecoration("Last name"),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

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
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          ctrl.setBirthDate(
                            "${picked.day}/${picked.month}/${picked.year}",
                          );
                        }
                      },
                      validator: (v) =>
                      v!.isEmpty ? "Date of Birth is required" : null,
                    );
                  },
                ),

                SizedBox(height: 15.h),

                // Profile Image Field with Error
                Row(
                  children: [
                    Expanded(
                      child: GetBuilder<SignupController>(
                        builder: (ctrl) {
                          return GestureDetector(
                            onTap: () => ctrl.selectProfileImage(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 65,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                      ctrl
                                          .profileImageError
                                          .value
                                          .isNotEmpty
                                          ? Colors.red
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          ctrl.profileImage.value == null
                                              ? "Profile Image"
                                              : "Profile Image Selected",
                                          style: TextStyle(
                                            fontSize:
                                            16,
                                            color:
                                            ctrl.profileImage.value == null
                                                ? Colors.black54
                                                : Colors.black54,
                                            fontWeight:
                                            ctrl.profileImage.value == null
                                                ? FontWeight.w500
                                                : FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow
                                              .ellipsis,
                                        ),
                                      ),
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.black45,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                                if (ctrl.profileImageError.value.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      top: 4,
                                    ),
                                    child: Text(
                                      ctrl.profileImageError.value,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(width: 10.h),

                    Expanded(
                      child: GetBuilder<SignupController>(
                        builder: (ctrl) {
                          return GestureDetector(
                            onTap: () => ctrl.pickIdImage(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 65,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: ctrl.idImageError.value.isNotEmpty
                                          ? Colors.red
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          ctrl.idImage.value == null
                                              ? "ID Image"
                                              : "ID Image Selected",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: ctrl.idImage.value == null
                                                ? Colors.black54
                                                : Colors.black54,
                                            fontWeight:
                                            ctrl.idImage.value == null
                                                ? FontWeight.w500
                                                : FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow
                                              .ellipsis,
                                        ),
                                      ),
                                      Icon(
                                        Icons.photo,
                                        color: Colors.black45,
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ),
                                // ⬅️ عرض رسالة الخطأ تحت الحقل
                                if (ctrl.idImageError.value.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      top: 4,
                                    ),
                                    child: Text(
                                      ctrl.idImageError.value,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                // Phone
                TextFormField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: const TextStyle(color: Colors.black87, fontSize: 22),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Phone is required";
                    if (v.length != 10) return "Phone must be 10 digits";
                    return null;
                  },
                  decoration: _inputDecoration("Phone", suffix: Icons.phone),
                ),

                SizedBox(height: 10.h),

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
                      validator: (v) {
                        if (v!.isEmpty) return "Password required";
                        if (v.length < 8) return "Must be at least 8 chars";
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
                          ),
                          onPressed: ctrl.togglePassword,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 10.h),

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
                      validator: (v) {
                        if (v!.isEmpty) return "Confirm is required";
                        if (v != ctrl.passwordController.text) {
                          return "Not matching";
                        }
                        return null;
                      },
                      decoration: _inputDecoration(
                        "Confirm Password",
                        suffixWidget: IconButton(
                          icon: Icon(
                            ctrl.isConfirmHidden ? Icons.lock : Icons.lock_open,
                            color: Colors.black45,
                          ),
                          onPressed: ctrl.toggleConfirmPassword,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20.h),

                // Sign Up Button
                GetBuilder<SignupController>(
                  builder: (ctrl) {
                    return ElevatedButton(
                      onPressed: ctrl.isLoading
                          ? null
                          : () => controller.signupUser(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF274668),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
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
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20.h),
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
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black45,
        fontSize: 18,
        overflow: TextOverflow.visible,
      ),
      suffixIcon:
      suffixWidget ??
          (suffix != null ? Icon(suffix, color: Colors.black45) : null),
      fillColor: const Color(0xFFF5F5F5),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF274668), width: 2),
      ),
    );
  }
}
