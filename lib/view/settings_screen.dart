import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/my_account_controller.dart';
import '../controller/authcontroller.dart';
import 'edit_profile.dart';
import 'language_selector_dialog.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final MyAccountController accountController = Get.find<MyAccountController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "Settings".tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF274668),
      ),
      body: ListView(
        children: [
          _sectionTitle("Account".tr),

          settingsCard(
            icon: Icons.edit,
            title: "Edit Profile".tr,
            subtitle: "Update your personal information".tr,
            onTap: () => Get.to(() => EditProfileScreen()),
          ),

          settingsCard(
            icon: Icons.logout,
            title: "Logout".tr,
            subtitle: "Sign out from your account".tr,
            onTap: () {
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title:  Text(
                    'Attention ! '.tr,
                    style: TextStyle(fontSize: 30),
                  ),
                  content: Text(
                    'Are you sure you want to logout?'.tr,
                    style: TextStyle(fontSize: 17),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child:  Text(
                        'CANCEL'.tr,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        authController.logout();
                        Get.back();
                      },

                      child: Text(
                        'Confirm'.tr,
                        style: TextStyle(
                          color: Color(0xFF274668),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          _sectionTitle("Preferences".tr),

          settingsCard(
            icon: Icons.dark_mode,
            title: "Theme".tr,
            subtitle: "Light / Dark mode".tr,
            enabled: false,
          ),

          settingsCard(
            icon: Icons.language,
            title: "Language".tr,
            subtitle: "Change app language".tr,
            onTap: showLanguageSelector,
          ),


          _sectionTitle("Danger Zone".tr),

          settingsCard(
            icon: Icons.delete,
            iconColor: Colors.red,
            title: "Delete Account".tr,
            textColor: Colors.red,
            subtitle: "Delete your account !".tr,
            onTap: () => accountController.showDeleteAccountFlow(context),
          ),
        ],
      ),
    );
  }

  Widget settingsCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: enabled ? iconColor ?? Colors.blueGrey : Colors.grey,
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
                        fontWeight: FontWeight.bold,
                        color: enabled
                            ? textColor ?? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (enabled) const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
