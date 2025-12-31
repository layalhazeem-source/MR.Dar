import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Edit Profile'.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF274668),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Obx(() => _buildProfileHeader(controller)),
              const SizedBox(height: 30),
              _buildSectionTitle('Personal Information'.tr, Icons.person_outline),
              _buildInfoCard(context, controller),
              const SizedBox(height: 25),
              _buildSectionTitle('Security'.tr, Icons.lock_outline),
              _buildPasswordCard(controller),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        if (!controller.hasAnyChanges.value) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(20),
          child: FloatingActionButton.extended(
            onPressed: () {
              if (controller.formKey.currentState!.validate()) {
                _showPasswordDialog(context, controller);
              } else {
                Get.snackbar(
                  "Validation Error".tr,
                  "Please fix the errors in the form".tr,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              }
            },
            backgroundColor: const Color(0xFF274668),
            icon: const Icon(Icons.check, color: Colors.white, size: 24),
            label:  Text(
              'SAVE CHANGES'.tr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(EditProfileController controller) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: ClipOval(
              child: controller.selectedImage.value != null
                  ? Image.file(
                      File(controller.selectedImage.value!.path),
                      fit: BoxFit.cover,
                    )
                  : (controller.myAccountController.user.value?.profileImage !=
                            null &&
                        controller
                            .myAccountController
                            .user
                            .value!
                            .profileImage!
                            .isNotEmpty)
                  ? Image.network(
                      controller.myAccountController.user.value!.profileImage!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: controller.selectProfileImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF274668),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.person, size: 60, color: Colors.grey),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    EditProfileController controller,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(
              controller: controller.firstNameController,
              label: 'First Name'.tr,
              icon: Icons.person,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required field'.tr : null,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: controller.lastNameController,
              label: 'Last Name'.tr,
              icon: Icons.person_outline,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required field'.tr : null,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: controller.phoneController,
              label: 'Phone Number'.tr,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => value == null || value.length < 10
                  ? 'Must be 10 digits'.tr
                  : null,
            ),
            const SizedBox(height: 15),
            GetBuilder<EditProfileController>(
              builder: (ctrl) {
                return TextFormField(
                  readOnly: true,
                  controller: ctrl.dobController,
                  decoration: InputDecoration(
                    labelText: "Date of Birth (Optional)".tr,
                    prefixIcon: const Icon(
                      Icons.cake_outlined,
                      color: Color(0xFF274668),
                    ),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF274668),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTap: () async {
                    DateTime initialDate = DateTime(2000);

                    if (ctrl.dobController.text.isNotEmpty) {
                      try {
                        initialDate = DateTime.parse(ctrl.dobController.text);
                      } catch (e) {
                        initialDate = DateTime(2000);
                      }
                    }

                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF274668),
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (picked != null) {
                      String formattedDate =
                          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      ctrl.setBirthDate(formattedDate);
                    }
                  },
                  validator: (v) => null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF274668)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        counterText: maxLength != null ? "" : null,
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordCard(EditProfileController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             Text(
              'Only fill to change password'.tr,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Obx(
              () => _passwordTextField(
                controller: controller.newPasswordController,
                label: 'New Password'.tr,
                showPassword: controller.showNewPassword.value,
                onToggleVisibility: () => controller.showNewPassword.toggle(),
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => _passwordTextField(
                controller: controller.confirmPasswordController,
                label: 'Confirm Password'.tr,
                showPassword: controller.showConfirmPassword.value,
                onToggleVisibility: () =>
                    controller.showConfirmPassword.toggle(),
                validator: (value) {
                  if (controller.newPasswordController.text.isNotEmpty) {
                    if (value == null || value.isEmpty)
                      return 'Please confirm your password'.tr;
                    if (value != controller.newPasswordController.text)
                      return 'Passwords do not match'.tr;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordTextField({
    required TextEditingController controller,
    required String label,
    required bool showPassword,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF274668)),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF274668)),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF274668),
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(
    BuildContext context,
    EditProfileController controller,
  ) {
    controller.clearDialogFields();
    controller.showDialogPassword.value = false;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title:  Text(
          'Confirm Your Identity'.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              'Enter your current password to save changes:'.tr,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Obx(
              () => TextFormField(
                controller: controller.confirmDialogPasswordController,
                obscureText: !controller.showDialogPassword.value,
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Current Password'.tr,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.showDialogPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => controller.showDialogPassword.toggle(),
                  ),
                  errorText: controller.dialogPasswordError.value,
                  errorStyle: const TextStyle(color: Colors.red),
                ),
                onChanged: (_) {
                  if (controller.dialogPasswordError.value != null) {
                    controller.dialogPasswordError.value = null;
                  }
                },
              ),
            ),

            const SizedBox(height: 10),
            Text(
              'This ensures your account security'.tr,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearDialogFields();
              Get.back();
            },
            child:  Text(
              'CANCEL'.tr,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF274668),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: controller.isUpdating.value
                  ? null
                  : () async {
                      final password = controller
                          .confirmDialogPasswordController
                          .text
                          .trim();

                      if (password.isEmpty) {
                        controller.dialogPasswordError.value =
                            'Password is required'.tr;
                        return;
                      }

                      final success = await controller.updateProfile(
                        currentPassword: password,
                      );

                      // 🔽 التعديل المهم هنا
                      if (success) {
                        // نجاح: نغلق الدايلوج أولاً
                        Get.back();

                        // ننتظر قليلاً ثم نغلق صفحة التعديل
                        await Future.delayed(const Duration(milliseconds: 300));

                        // نغلق صفحة EditProfileScreen
                        Get.back();

                        // نظهر رسالة النجاح
                        Get.snackbar(
                          "Success".tr,
                          "Your profile has been updated successfully".tr,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        // فشل: نظهر الخطأ في الدايلوج (الدائالوج يبقى مفتوح)
                        // لا نعمل Get.back() هنا
                        if (controller.dialogPasswordError.value == "Success".tr) {
                          Get.back();

                          // ننتظر قليلاً ثم نغلق صفحة التعديل
                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );

                          // نغلق صفحة EditProfileScreen
                          Get.back();
                        }
                      }
                    },
              child: controller.isUpdating.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  :  Text(
                      'SAVE CHANGES'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
