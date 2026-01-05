import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import '../service/UserLocalService.dart';
import '../service/userService.dart';
import 'authcontroller.dart';

class MyAccountController extends GetxController {
  final UserService service;
  final UserLocalService localService = UserLocalService();
  final isDeleting = false.obs;
  final deletePasswordController = TextEditingController();
  MyAccountController({required this.service});
  final AuthController authController = Get.find<AuthController>();

  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isDataFromLocal = false.obs;
  bool get isAccountActive {
    return user.value?.status == 'accepted';
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProfile();
    });
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      update();

      final localData = await localService.getUserData();
      if (localData['token'] != null && localData['id'] != null) {
        user.value = _createUserFromLocalData(localData);
        isDataFromLocal.value = true;

        // 🔽 تحقق من رابط الصورة
        if (user.value?.profileImage != null &&
            user.value!.profileImage!.isNotEmpty) {
          await checkImageUrl(user.value!.profileImage!);
        }
      }

      try {
        final apiUser = await service.getProfile();
        user.value = apiUser;
        isDataFromLocal.value = false;

        // تحديث البيانات المحلية
        await _updateLocalData(apiUser);

        // 🔽 تحقق من رابط الصورة بعد التحميل من API
        if (user.value?.profileImage != null &&
            user.value!.profileImage!.isNotEmpty) {
          await checkImageUrl(user.value!.profileImage!);
        }
      } catch (e) {
        print("Failed to fetch from API: $e");
        if (user.value == null) {
          throw Exception("No data available");
        }
      }
    } catch (e) {
      print("Error loading profile: $e");
      if (user.value == null) {
        user.value = null;
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    print('🖼️ Original URL: $url');

    // إصلاح الروابط النسبية
    if (!url.startsWith('http')) {
      if (url.startsWith('/storage/')) {
        final fixed = 'http://10.0.2.2:8000$url';
        print('🛠️ Fixed URL (with slash): $fixed');
        return fixed;
      } else if (url.startsWith('storage/')) {
        final fixed = 'http://10.0.2.2:8000/storage/${url.substring(8)}';
        print('🛠️ Fixed URL (without slash): $fixed');
        return fixed;
      }
    }

    // إصلاح localhost لـ Android emulator
    if (url.contains('localhost:8000')) {
      return url.replaceAll('localhost:8000', '10.0.2.2:8000');
    }

    if (url.contains('127.0.0.1:8000')) {
      return url.replaceAll('127.0.0.1:8000', '10.0.2.2:8000');
    }

    return url;
  }

  Future<void> checkImageUrl(String url) async {
    try {
      print('🔍 Testing image URL: $url');
      final response = await Dio().head(url);
      print('✅ Image exists - Status: ${response.statusCode}');
    } catch (e) {
      print('❌ Image not accessible: $e');
    }
  }

  UserModel _createUserFromLocalData(Map<String, dynamic> data) {
    return UserModel(
      id: int.tryParse(data['id'] ?? '0') ?? 0,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? 'renter',
      dateOfBirth: data['date_of_birth'] ?? '',
      profileImage: _fixImageUrl(data['profile_image']),
      idImage: _fixImageUrl(data['id_image']),
      status: data['status'] ?? 'rejected',
    );
  }

  Future<void> _updateLocalData(UserModel user) async {
    await localService.saveUserData({
      'id': user.id.toString(),
      'first_name': user.firstName,
      'last_name': user.lastName,
      'phone': user.phone,
      'role': user.role,
      'date_of_birth': user.dateOfBirth,
      'profile_image': user.profileImage,
      'id_image': user.idImage,
      'status': user.status,
    });
  }

  Future<void> updateUserAfterSignup(Map<String, dynamic> userData) async {
    await localService.saveUserData(userData);
    user.value = _createUserFromLocalData(userData);
    isDataFromLocal.value = true;
    update();
  }

  Future<void> verifyAndDeleteAccount(String password) async {
    if (password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your password",
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      isDeleting.value = true;

      final response = await service.deleteAccount(password);

      if (response['status'] == 'success' || response['message'] != null) {
        if (Get.isDialogOpen!) Get.back();
        final authController = Get.find<AuthController>();
        await authController.logout();

        Get.snackbar(
          "Account Deleted",
          "Your account has been permanently removed",
          backgroundColor: Colors.black,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Delete Error: $e");
      Get.snackbar(
        "Failed",
        "Could not delete account. Please check your password.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDeleting.value = false;
    }
  }

  void showDeleteAccountFlow(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Attention!".tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to delete your account?\nThis action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // سكّر Dialog التأكيد
              _showPasswordVerifyDialog(context); // نفس الفلو تبعك
            },
            child: const Text(
              "Confirm",
              style: TextStyle(
                color: Color(0xFF274668),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Attention!".tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Are you sure you want to logout?".tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel".tr, style: const TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              authController.logout();
              Get.back();
            },
            child: Text(
              "Confirm".tr,
              style: const TextStyle(
                color: Color(0xFF274668),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordVerifyDialog(BuildContext context) {
    deletePasswordController.clear();

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
              controller: deletePasswordController,
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
              onPressed: isDeleting.value
                  ? null
                  : () => verifyAndDeleteAccount(deletePasswordController.text),
              child: isDeleting.value
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

  static void refreshProfile() {
    final controller = Get.find<MyAccountController>();
    controller.loadProfile();
  }

  @override
  void onClose() {
    deletePasswordController.dispose();
    super.onClose();
  }
}
