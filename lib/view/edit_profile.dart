import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // مهم للـ inputFormatters
import 'package:get/get.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF274668),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Obx(() => _buildProfileHeader(controller)),
              const SizedBox(height: 30),
              _buildSectionTitle('Personal Information', Icons.person_outline),
              _buildInfoCard(controller),
              const SizedBox(height: 25),
              _buildSectionTitle('Security', Icons.lock_outline),
              _buildPasswordCard(controller),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        if (!controller.hasAnyChanges.value) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: () {
            if (controller.formKey.currentState!.validate()) {
              _showConfirmDialog(context, controller);
            }
          },
          backgroundColor: const Color(0xFF274668),
          icon: const Icon(Icons.check, color: Colors.white),
          label: const Text(
            'Save Changes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(EditProfileController controller) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey[200],
            backgroundImage: controller.selectedImage.value != null
                ? FileImage(File(controller.selectedImage.value!.path))
                      as ImageProvider
                : (controller.myAccountController.user.value?.profileImage !=
                          null
                      ? NetworkImage(
                          controller
                              .myAccountController
                              .user
                              .value!
                              .profileImage!,
                        )
                      : null),
            child:
                (controller.selectedImage.value == null &&
                    controller.myAccountController.user.value?.profileImage ==
                        null)
                ? Icon(Icons.person, size: 65, color: Colors.grey[400])
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: controller.selectProfileImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF274668),
                  shape: BoxShape.circle,
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

  Widget _buildInfoCard(EditProfileController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _simpleTextField(
              controller.firstNameController,
              'First Name',
              Icons.person,
            ),
            const SizedBox(height: 15),
            _simpleTextField(
              controller.lastNameController,
              'Last Name',
              Icons.person_outline,
            ),
            const SizedBox(height: 15),
            // حقل الهاتف مع تحديد الحد الأقصى 10 أرقام
            TextFormField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ], // يسمح بالأرقام فقط
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF274668)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                counterText: "", // لإخفاء عداد الأرقام الصغير تحت الحقل
              ),
              validator: (v) =>
                  (v == null || v.length < 10) ? 'Must be 10 digits' : null,
            ),
          ],
        ),
      ),
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
            const Text(
              'Only fill to change password',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Obx(
              () => _passwordTextField(
                controller: controller.newPasswordController,
                label: 'New Password',
                showRx: controller.showNewPassword,
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => _passwordTextField(
                controller: controller.confirmPasswordController,
                label: 'Confirm Password',
                showRx: controller.showConfirmPassword,
                validator: (value) {
                  if (controller.newPasswordController.text.isNotEmpty) {
                    if (value == null || value.isEmpty)
                      return 'Please confirm your password';
                    if (value != controller.newPasswordController.text)
                      return 'Passwords do not match';
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

  Widget _simpleTextField(
    TextEditingController ctrl,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF274668)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Required field' : null,
    );
  }

  Widget _passwordTextField({
    required TextEditingController controller,
    required String label,
    required RxBool showRx,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showRx.value,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF274668)),
        suffixIcon: IconButton(
          icon: Icon(showRx.value ? Icons.visibility : Icons.visibility_off),
          onPressed: () => showRx.toggle(),
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

  void _showConfirmDialog(
    BuildContext context,
    EditProfileController controller,
  ) {
    // تصفير حقل كلمة السر في الديالوج قبل فتحه
    controller.confirmDialogPasswordController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm Identity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your current password to apply changes:'),
            const SizedBox(height: 15),
            TextField(
              controller: controller.confirmDialogPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            // استخدام Navigator.pop لضمان إغلاق الديالوج حصراً
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF274668),
              ),
              onPressed: controller.isUpdating.value
                  ? null
                  : () async {
                      String pass =
                          controller.confirmDialogPasswordController.text;
                      if (pass.isEmpty) return;

                      bool success = await controller.saveAllChanges(pass);

                      // إغلاق الديالوج أولاً
                      Navigator.of(context).pop();

                      if (success) {
                        Get.snackbar(
                          'Success',
                          'Profile updated successfully',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                        );
                      } else {
                        // إظهار سبب الفشل (مثلاً كلمة السر غلط)
                        Get.snackbar(
                          'Update Failed',
                          controller.errorMessage.value,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          icon: const Icon(
                            Icons.error_outline,
                            color: Colors.white,
                          ),
                          duration: const Duration(seconds: 4),
                        );
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
                  : const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
