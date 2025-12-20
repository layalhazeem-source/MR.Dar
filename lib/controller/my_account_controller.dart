import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import '../service/UserLocalService.dart';
import '../service/userService.dart';

class MyAccountController extends GetxController {
  final UserService service;
  final UserLocalService localService = UserLocalService();

  MyAccountController(this.service);

  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isDataFromLocal = false.obs;

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

      // محاولة تحميل البيانات من الذاكرة المحلية أولاً
      final localData = await localService.getUserData();
      if (localData['token'] != null && localData['id'] != null) {
        user.value = _createUserFromLocalData(localData);
        isDataFromLocal.value = true;
      }

      // ثم محاولة تحديث البيانات من API
      try {
        final apiUser = await service.getProfile();
        user.value = apiUser;
        isDataFromLocal.value = false;

        // تحديث البيانات المحلية
        await _updateLocalData(apiUser);
      } catch (e) {
        print("Failed to fetch from API: $e");
        // إذا فشل الاتصال بالAPI، نستخدم البيانات المحلية
        if (user.value == null) {
          throw Exception("No data available");
        }
      }
    } catch (e) {
      print("Error loading profile: $e");
      // إذا لم توجد بيانات محلية أيضاً
      if (user.value == null) {
        user.value = null;
      }
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // في lib/controller/my_account_controller.dart
  String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';

    // إذا كان الرابط يبدأ بـ storage/ وغير كامل
    if (url.startsWith('storage/')) {
      return 'http://10.0.2.2:8000/storage/${url.substring(8)}';
    }

    // إذا كان الرابط نسبي
    if (url.startsWith('/storage/')) {
      return 'http://10.0.2.2:8000$url';
    }

    // إذا كان الرابط يحتوي على localhost، استبدله بـ 10.0.2.2
    if (url.contains('localhost:8000')) {
      return url.replaceAll('localhost:8000', '10.0.2.2:8000');
    }

    if (url.contains('127.0.0.1:8000')) {
      return url.replaceAll('127.0.0.1:8000', '10.0.2.2:8000');
    }

    return url;
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
    });
  }

  // دالة لتحديث بيانات المستخدم بعد التسجيل
  Future<void> updateUserAfterSignup(Map<String, dynamic> userData) async {
    await localService.saveUserData(userData);
    user.value = _createUserFromLocalData(userData);
    isDataFromLocal.value = true;
    update();
  }
}
