import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../service/userService.dart';
import '../view/WelcomePage.dart';

class MyAccountController extends GetxController {
  final UserService service;
  MyAccountController(this.service);

  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  Future<void> fetchProfile() async {
    print("🔄 [MY ACCOUNT] fetchProfile() started");

    try {
      isLoading.value = true;
      update(); // ⬅️ مهم لتحديث UI

      print("📡 [MY ACCOUNT] Calling service.getProfile()");

      // 1. أولاً حاول تجلب من API
      final UserModel fetchedUser = await service.getProfile();
      print("✅ [MY ACCOUNT] User fetched from API:");
      print("   ID: ${fetchedUser.id}");
      print("   Name: ${fetchedUser.firstName} ${fetchedUser.lastName}");
      print("   Role: ${fetchedUser.role}");
      print("   Profile Image: ${fetchedUser.profileImage}");
      print("   ID Image: ${fetchedUser.idImage}");

      user.value = fetchedUser;
    } catch (e) {
      print("❌ [MY ACCOUNT] API Error: $e");

      // 2. إذا فشل API، جلب من SharedPreferences
      print("🔄 [MY ACCOUNT] Falling back to SharedPreferences...");
      await _loadUserFromPrefs();
    } finally {
      isLoading.value = false;
      update();
      print("🔚 [MY ACCOUNT] fetchProfile() completed");
    }
  }

  Future<void> _loadUserFromPrefs() async {
    try {
      print("🔍 [MY ACCOUNT] Loading from SharedPreferences...");
      final prefs = await SharedPreferences.getInstance();

      // طباعة كل البيانات المخزنة للتأكد
      print("📊 [MY ACCOUNT] All stored data:");
      prefs.getKeys().forEach((key) {
        if (key.startsWith('token') || key.contains('image')) {
          print("   $key: ${prefs.get(key)?.toString().substring(0, 30)}...");
        } else {
          print("   $key: ${prefs.get(key)}");
        }
      });

      final userModel = UserModel(
        id: int.tryParse(prefs.getString("id") ?? "0") ?? 0,
        firstName: prefs.getString("first_name") ?? "Unknown",
        lastName: prefs.getString("last_name") ?? "User",
        phone: prefs.getString("phone") ?? "Not set",
        role: prefs.getString("role") ?? "guest",
        dateOfBirth: prefs.getString("date_of_birth") ?? "Not set",
        profileImage: prefs.getString("profile_image"),
        idImage: prefs.getString("id_image"),
      );

      if (userModel.id > 0 || userModel.firstName != "Unknown") {
        user.value = userModel;
        print("✅ [MY ACCOUNT] Loaded from SharedPreferences");
      } else {
        print("⚠️ [MY ACCOUNT] No valid data in SharedPreferences");
      }
    } catch (e) {
      print("💥 [MY ACCOUNT] Error loading from prefs: $e");
    }
  }

  Future<void> logout() async {
    await service.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => WelcomePage());
  }
}
