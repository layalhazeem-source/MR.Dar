import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Color(0xFF274668),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // ===== رسائل النجاح/الخطأ =====
                if (controller.errorMessage.value.isNotEmpty)
                  _buildMessageCard(
                    controller.errorMessage.value,
                    Colors.red.shade50,
                    Colors.red,
                  ),
                if (controller.successMessage.value.isNotEmpty)
                  _buildMessageCard(
                    controller.successMessage.value,
                    Colors.green.shade50,
                    Colors.green,
                  ),

                SizedBox(height: 20),

                // ===== صورة الملف الشخصي =====
                _buildProfileImageSection(),

                SizedBox(height: 30),

                // ===== المعلومات الأساسية =====
                _buildBasicInfoSection(),

                SizedBox(height: 30),

                // ===== تغيير كلمة المرور =====
                _buildPasswordSection(),

                SizedBox(height: 40),
              ],
            ),
          );
        }),
        floatingActionButton: Obx(() {
          // ✅ تحقق من وجود أي تغييرات صحيحة
          final hasValidChanges = controller.hasValidChanges;
          final changesError = controller.changesError;

          // ✅ إخفاء الزر إذا مافي تغييرات
          if (!hasValidChanges) return SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () => _showSaveDialog(context),
            icon: Icon(Icons.save),
            label: Text('Save Changes'),
            backgroundColor: Color(0xFF274668),
            foregroundColor: Colors.white,
            tooltip: changesError ?? 'Save your changes',
          );
        }),
      ),
    );
  }

  Widget _buildMessageCard(String message, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(message, style: TextStyle(color: textColor, fontSize: 14)),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        Text(
          'Profile Picture',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF274668),
          ),
        ),
        SizedBox(height: 16),

        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Obx(() {
              final currentImage = controller.currentProfileImage;
              final selectedImage = controller.selectedImage.value;

              if (selectedImage != null) {
                return CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(File(selectedImage.path)),
                );
              } else if (currentImage != null && currentImage.isNotEmpty) {
                return CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(currentImage),
                  backgroundColor: Colors.transparent,
                );
              } else {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                );
              }
            }),

            Container(
              decoration: BoxDecoration(
                color: Color(0xFF274668),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                onPressed: controller.selectProfileImage,
              ),
            ),
          ],
        ),

        SizedBox(height: 8),
        Text(
          'Tap camera icon to change photo',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF274668),
                ),
              ),
              SizedBox(height: 20),

              // First Name
              TextFormField(
                controller: controller.firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Last Name
              TextFormField(
                controller: controller.lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,

                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone is required';
                  }
                  if (value.length != 10) {
                    return 'Phone must be 10 digits';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Obx(() {
      controller.passwordTextTrigger.value;

      final hasPasswordChanges = controller.hasPasswordOnlyChanges;
      final isValid = controller.isPasswordChangeValid();

      return Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: controller.passwordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF274668),
                  ),
                ),

                if (hasPasswordChanges)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isValid
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isValid ? 'Ready' : 'Incomplete',
                      style: TextStyle(
                        fontSize: 12,
                        color: isValid ? Colors.green.shade800 : Colors.orange,
                      ),
                    ),
                  ),

                SizedBox(height: 20),

                // Current Password
                TextFormField(
                  controller: controller.currentPasswordController,
                  obscureText: !controller.showCurrentPassword.value,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.showCurrentPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: controller.showCurrentPassword.toggle,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // New Password
                TextFormField(
                  controller: controller.newPasswordController,
                  obscureText: !controller.showNewPassword.value,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.showNewPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: controller.showNewPassword.toggle,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.showConfirmPassword.value,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.showConfirmPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: controller.showConfirmPassword.toggle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ✅ دالة مساعدة لعرض قائمة التحقق
  Widget _buildChecklistItem(String text, bool isChecked) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isChecked ? Colors.green : Colors.grey,
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: isChecked ? Colors.green : Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Changes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.hasChanges)
              Text('You have changed your profile information.'),
            if (controller.hasPasswordChanges)
              Text('You have changed your password.'),
            SizedBox(height: 10),
            Text('Please enter your current password to confirm:'),
            SizedBox(height: 10),
            Obx(
              () => TextFormField(
                controller: controller.confirmDialogPasswordController,
                obscureText: !controller.showCurrentPassword.value,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.showCurrentPassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.showCurrentPassword.toggle,
                  ),
                ),
              ),
            ),
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                );
              }
              return SizedBox();
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.confirmDialogPasswordController.clear();
              controller.errorMessage.value = '';
              Get.back();
            },
            child: Text('Cancel'),
          ),
          Obx(() {
            return ElevatedButton(
              onPressed: controller.isUpdating.value
                  ? null
                  : () async {
                      final password = controller
                          .confirmDialogPasswordController
                          .text
                          .trim();

                      if (password.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter your current password',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      bool success = false;
                      try {
                        if (controller.hasPasswordChanges) {
                          print("🔄 Changing password...");
                          success = await controller.changePassword();
                        } else if (controller.hasChanges) {
                          print("🔄 Updating profile...");
                          success = await controller.updateProfile(
                            password: password,
                          );
                        }

                        if (success) {
                          print("✅ Success! Closing dialog...");
                          controller.confirmDialogPasswordController.clear();
                          controller.errorMessage.value = '';
                          Get.back(); // ✅ ديالوج بيقفل هنا

                          // ⚠️ بعد ما الديالوج يقفل، ممكن تعمل snackbar
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Get.snackbar(
                              'Success',
                              'Changes saved successfully!',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                            );
                          });
                        } else {
                          print(
                            "❌ Failed with error: ${controller.errorMessage.value}",
                          );
                          // الخطأ رح يظهر في الديالوج بسبب الـ Obx فوق
                        }
                      } catch (e) {
                        print("❌ Exception: $e");
                        controller.errorMessage.value =
                            'Something went wrong: $e';
                      }
                    },

              child: controller.isUpdating.value
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Text('Save Changes'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            );
          }),
        ],
      ),
    ).then((value) {
      // ديالوج سكر
      controller.confirmDialogPasswordController.clear();
      controller.errorMessage.value = '';
    });
  }
}
