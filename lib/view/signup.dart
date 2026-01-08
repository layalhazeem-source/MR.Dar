
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Join us & find your perfect home".tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        elevation: 0,
        iconTheme:  IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,

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
                    onTap: () => ctrl.setRole('renter'.tr),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: ctrl.role.value == 'renter'.tr
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surfaceVariant,
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
                                  "renter".tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ctrl.role.value == 'renter'.tr
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                    onTap: () => ctrl.setRole('owner'.tr),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: ctrl.role.value == 'owner'.tr
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surfaceVariant,
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
                                  "owner".tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ctrl.role.value == 'owner'.tr
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.primary,
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
                        style:  TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 22,
                        ),
                        validator: (v) =>
                        v!.isEmpty ? "First name is required!".tr : null,
                        decoration: _inputDecoration(context,"First name".tr),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: controller.lastNameController,
                        maxLength: 20,
                        style:  TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 22,
                        ),
                        validator: (v) =>
                        v!.isEmpty ? "Last name is required!".tr : null,
                        decoration: _inputDecoration(context,"Last name".tr),
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
                        context,
                        "Date of Birth".tr,
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
                      v!.isEmpty ? "Date of Birth is required".tr : null,
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
                                    color: Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: ctrl.profileImageError.value.isNotEmpty
                                          ? Theme.of(context).colorScheme.error
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
                                              ? "Profile Image".tr
                                              : "Profile Image Selected".tr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
                                    color: Theme.of(context).colorScheme.surface,
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
                                              ? "ID Image".tr
                                              : "ID Image Selected".tr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
                    if (v == null || v.isEmpty) return "Phone required!".tr;
                    if (v.length != 10) return "Must be 10 digits".tr;
                    return null;
                  },
                  decoration: _inputDecoration(context,"Phone Number".tr, suffix: Icons.phone),
                ),

                SizedBox(height: 10.h),

                // Password
                GetBuilder<SignupController>(
                  builder: (ctrl) {
                    return TextFormField(
                      controller: ctrl.passwordController,
                      obscureText: ctrl.isPasswordHidden,
                      maxLength: 15,
                      style:  TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 22,
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return "Password required!".tr;
                        if (v.length < 8) return "Min 8 characters!".tr;
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
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                      style:  TextStyle(
                        color:Theme.of(context).colorScheme.onSurface,
                        fontSize: 22,
                      ),
                      validator: (v) {
                        if (v!.isEmpty) return "Confirm is required".tr;
                        if (v != ctrl.passwordController.text) {
                          return "Not matching".tr;
                        }
                        return null;
                      },
                      decoration: _inputDecoration(
                        context,
                        "Confirm Password".tr,
                        suffixWidget: IconButton(
                          icon: Icon(
                            ctrl.isConfirmHidden ? Icons.lock : Icons.lock_open,
                            color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: ctrl.isLoading
                          ? SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                          strokeWidth: 3,
                        ),
                      )
                          :  Text(
                        "Sign Up".tr,
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
      BuildContext context,
      String label, {
        IconData? suffix,
        Widget? suffixWidget,
      }) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        fontSize: 18,
        overflow: TextOverflow.visible,
      ),
      suffixIcon:
      suffixWidget ??
          (suffix != null ? Icon(
            suffix,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withOpacity(0.6),
          )
              : null),
      fillColor: isLight
          ? Colors.grey.shade100   // رمادي ناعم بالـ Light
          : Theme.of(context).colorScheme.surface,
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
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
    );
  }
}
