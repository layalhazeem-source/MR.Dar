import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class MyAccountController extends GetxController {
  var user = Rxn<UserModel>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();

      // طباعة كل البيانات المخزنة للتشخيص
      print("📱 SharedPreferences Data:");
      print("   id: ${prefs.getString("id")}");
      print("   first_name: ${prefs.getString("first_name")}");
      print("   last_name: ${prefs.getString("last_name")}");
      print("   phone: ${prefs.getString("phone")}");
      print("   role: ${prefs.getString("role")}");
      print("   date_of_birth: ${prefs.getString("date_of_birth")}");
      print("   token: ${prefs.getString("token")?.substring(0, 20)}...");

      final userData = {
        "id": prefs.getString("id") ?? "0",
        "first_name": prefs.getString("first_name") ?? "Unknown",
        "last_name": prefs.getString("last_name") ?? "",
        "phone": prefs.getString("phone") ?? "",
        "role": prefs.getString("role") ?? "renter",
        "date_of_birth": prefs.getString("date_of_birth") ?? "",
      };

      user.value = UserModel.fromPrefs(userData);
      isLoading.value = false;

      print("✅ User loaded: ${user.value?.firstName} ${user.value?.lastName}");
    } catch (e) {
      isLoading.value = false;
      print("❌ Error loading user: $e");
    }
  }

  // دالة للتحديث
  Future<void> refreshUser() async {
    await loadUser();
  }
}
