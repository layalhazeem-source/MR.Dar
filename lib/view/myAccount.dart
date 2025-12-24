import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/my_account_controller.dart';
import '../controller/authcontroller.dart';
import '../model/user_model.dart';
import 'edit_profile.dart';

class MyAccount extends StatelessWidget {
  MyAccount({super.key});

  final MyAccountController controller = Get.find<MyAccountController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = controller.user.value;

      // No user
      if (user == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 60, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "No user data",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => controller.loadProfile(),
                child: Text("Retry"),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== مؤشر مصدر البيانات =====
            if (controller.isDataFromLocal.value)
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.amber[700]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Showing cached data. Pull to refresh for latest.",
                        style: TextStyle(color: Colors.amber[800]),
                      ),
                    ),
                  ],
                ),
              ),
            // ===== Header Card =====
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Profile Image - استبدل هذا الجزء
                    _buildProfileImage(user),
                    const SizedBox(width: 20),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${user.firstName} ${user.lastName}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Text(
                            user.role,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ===== User Details =====
            _buildInfoCard("📱", "Phone", user.phone),
            _buildInfoCard("🎂", "Date of Birth", user.dateOfBirth),
            const SizedBox(height: 30),
            _buildIdImage(user),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ===== Refresh Button =====
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.loadProfile(),
                    icon: Icon(Icons.refresh),
                    label: Text("Refresh Data"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // زر التعديل
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.to(() => EditProfileScreen()),
                    icon: Icon(Icons.edit),
                    label: Text("Edit Profile"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            // ===== Logout Button =====
            Center(
              child: ElevatedButton.icon(
                onPressed: () => authController.logout(),
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => _confirmDeleteSequence(context),
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _confirmDeleteSequence(BuildContext context) {
    // الديالوج الأول: تحذير عام
    Get.defaultDialog(
      title: "Delete Account?",
      middleText: "Are you sure? This action cannot be undone.",
      textConfirm: "Next",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back(); // إغلاق التحذير
        _showPasswordVerifyDialog(context); // الانتقال للتحقق
      },
    );
  }

  void _showPasswordVerifyDialog(BuildContext context) {
    controller.deletePasswordController.clear();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Verify Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Please enter your password to confirm deletion:"),
            const SizedBox(height: 15),
            TextField(
              controller: controller.deletePasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: controller.isDeleting.value
                  ? null
                  : () => controller.verifyAndDeleteAccount(
                      controller.deletePasswordController.text,
                    ),
              child: controller.isDeleting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Confirm Delete",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildProfileImage(UserModel user) {
    if (user.profileImage != null && user.profileImage!.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(user.profileImage!),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[200],
        child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
      );
    }
  }

  Widget _buildIdImage(UserModel user) {
    if (user.idImage != null && user.idImage!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ID Image",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              user.idImage!,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 40),
                        SizedBox(height: 10),
                        Text(
                          "Failed to load image",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildInfoCard(String emoji, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
