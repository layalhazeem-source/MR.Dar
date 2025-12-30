import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/view/settings_screen.dart';
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
              const Icon(Icons.person_off, size: 60, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                "No user data",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => controller.loadProfile(),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // ===== Cached data indicator =====
            if (controller.isDataFromLocal.value)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.amber[700]),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Showing cached data. Pull to refresh for latest.",
                      ),
                    ),
                  ],
                ),
              ),

            // ===== Profile Header =====
            _buildProfileHeader(user),

            const SizedBox(height: 30),

            // ===== Options =====
            _profileOption(
              icon: Icons.edit,
              title: "Edit account information",
              onTap: () async {
                await Get.to(() => EditProfileScreen());
                // إعادة تحميل البيانات عند الرجوع من صفحة التعديل
                controller.loadProfile();
              },
            ),
            const SizedBox(height: 10),

            // ===== Options =====
            _profileOption(
              icon: Icons.settings,
              title: "Settings",
              onTap: () => Get.to(() => SettingsScreen()),
            ),

            const SizedBox(height: 15),

            // ===== Refresh Button =====
            OutlinedButton.icon(
              onPressed: () => controller.loadProfile(),
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh Profile"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      );
    });
  }

  // ================= Widgets =================

  Widget _buildProfileHeader(UserModel user) {
    return Column(
      children: [
        _buildProfileImage(user),
        const SizedBox(height: 14),

        Text(
          "${user.firstName} ${user.lastName}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),

        Text(
          user.role,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),

        Text(
          user.phone,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildProfileImage(UserModel user) {
    final imageUrl = user.profileImage;

    // تحقق إنو الرابط موجود وصالح وURL كامل
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        Uri.tryParse(imageUrl)?.hasScheme == true &&
        Uri.tryParse(imageUrl)?.hasAuthority == true) {
      return CircleAvatar(
        radius: 48,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        radius: 48,
        backgroundColor: Colors.grey[200],
        child: Icon(Icons.person, size: 42, color: Colors.grey[600]),
      );
    }
  }

  Widget _profileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
