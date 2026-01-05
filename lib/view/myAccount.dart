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
      // Loading State
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF274668)),
          ),
        );
      }

      final user = controller.user.value;

      // No User Data
      if (user == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                "No Profile Data".tr,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => controller.loadProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF274668),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  "Try Again".tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Cached Data Indicator
            if (controller.isDataFromLocal.value)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Showing cached data. Pull to refresh for latest updates"
                            .tr,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            // Profile Header
            _buildProfileHeader(user),

            const SizedBox(height: 30),

            // Options Section
            _buildOptionsSection(),

            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }

  Widget _buildProfileHeader(UserModel user) {
    return Column(
      children: [
        // Profile Image
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 3),
          ),
          child: ClipOval(
            child: user.profileImage != null && user.profileImage!.isNotEmpty
                ? Image.network(
                    user.profileImage!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: const Color(0xFF274668),
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

        const SizedBox(height: 16),

        // Name
        Text(
          "${user.firstName} ${user.lastName}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF274668),
          ),
        ),
        const SizedBox(height: 10),

        // Phone
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              user.phone,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Role
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: user.role == 'owner'.tr
                    ? Colors.blue.shade50
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: getAccountStatusColor(user.status),
                  width: 1,
                ),
              ),
              child: Text(
                user.role.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: user.role == 'owner'.tr
                      ? Colors.blue.shade700
                      : Colors.green.shade700,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Refresh Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),

              child: OutlinedButton.icon(
                onPressed: () => controller.loadProfile(),
                icon: const Icon(Icons.refresh),
                label: Text(""),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: const BorderSide(color: Color(0xFF274668), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: getAccountStatusColor(user.status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: getAccountStatusColor(user.status),
                  width: 1,
                ),
              ),
              child: Text(
                getAccountStatusLabel(user.status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: getAccountStatusColor(user.status),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: Icon(Icons.person, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      children: [
        _buildOptionCard(
          icon: Icons.edit_outlined,
          title: "Edit Profile".tr,
          subtitle: "Update your personal information".tr,
          onTap: () async {
            await Get.to(() => EditProfileScreen())?.then((value) {
              // إذا كانت النتيجة 'updated' نحدث البيانات
              if (value == 'updated') {
                controller.loadProfile();
              }
            });
          },
        ),
        const SizedBox(height: 12),

        _buildOptionCard(
          icon: Icons.settings_outlined,
          title: "Settings".tr,
          subtitle: "App preferences and configurations".tr,
          onTap: () => Get.to(() => SettingsScreen()),
        ),

        const SizedBox(height: 24),

        // ===== Logout =====
        _buildOptionCard(
          icon: Icons.logout,
          title: "Logout".tr,
          subtitle: "Sign out from your account".tr,
          onTap: () => controller.showLogoutDialog(),
        ),

        const SizedBox(height: 12),

        // ===== Delete Account =====
        _buildOptionCard(
          icon: Icons.delete_outline,
          title: "Delete Account".tr,
          subtitle: "This action cannot be undone".tr,
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () => controller.showDeleteAccountFlow(Get.context!),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF274668).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor ?? Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF274668)),
            ],
          ),
        ),
      ),
    );
  }

  String getAccountStatusLabel(String status) {
    switch (status) {
      case 'accepted':
        return 'ACTIVE';
      case 'blocked':
        return 'BLOCKED';
      case 'rejected':
      default:
        return 'INACTIVE';
    }
  }

  Color getAccountStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'blocked':
        return Colors.red;
      case 'rejected':
      default:
        return Colors.orange;
    }
  }

  void _handleEditProfileResult() async {
    // ننتظر قليلاً للتأكد من اكتمال التحديث
    await Future.delayed(const Duration(milliseconds: 300));

    // نجبر على تحديث البيانات
    controller.loadProfile();
  }
}
