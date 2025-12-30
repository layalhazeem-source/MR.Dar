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
        title: const Text(
          'Edit Profile',
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
              _buildSectionTitle('Personal Information', Icons.person_outline),
              _buildInfoCard(context, controller),
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
            TextFormField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF274668)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                counterText: "",
              ),
              validator: (v) =>
                  (v == null || v.length < 10) ? 'Must be 10 digits' : null,
            ),
            const SizedBox(height: 15),
            // Date of Birth - Optional Field
            // Date of Birth - Optional Field
            GetBuilder<EditProfileController>(
              builder: (ctrl) {
                return TextFormField(
                  readOnly: true,
                  controller: ctrl.dobController,
                  decoration: InputDecoration(
                    labelText: "Date of Birth (Optional)",
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
            const SizedBox(height: 15),
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
    controller.confirmDialogPasswordController.clear();
    controller.dialogPasswordError.value = null;
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm Identity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your current password to apply changes:'),
            const SizedBox(height: 15),
            Obx(
              () => TextFormField(
                controller: controller.confirmDialogPasswordController,
                obscureText: true,
                onChanged: (_) {
                  if (controller.dialogPasswordError.value != null) {
                    controller.dialogPasswordError.value = null;
                  }
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Current Password',
                  prefixIcon: const Icon(Icons.lock),
                  errorText: controller.dialogPasswordError.value,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
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
                      final pass = controller
                          .confirmDialogPasswordController
                          .text
                          .trim();

                      if (pass.isEmpty) {
                        controller.dialogPasswordError.value =
                            'Password is required';
                        return;
                      }

                      final success = await controller.saveAllChanges(pass);

                      if (!success) {
                        controller.dialogPasswordError.value =
                            controller.errorMessage.value;
                      }
                      Get.back();
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
