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

      final userData = {
        "id": prefs.getString("id") ?? "0",
        "first_name": prefs.getString("first_name") ?? "Unknown",
        "last_name": prefs.getString("last_name") ?? "",
        "phone": prefs.getString("phone") ?? "",
        "role": prefs.getString("role") ?? "renter",
        "date_of_birth": prefs.getString("date_of_birth") ?? "",
        "profileImage": prefs.getString("profile_image") ?? "",
        "idImage": prefs.getString("id_image") ?? "",
      };

      user.value = UserModel.fromPrefs(userData);
      isLoading.value = false;

      print(" User loaded: ${user.value?.firstName} ${user.value?.lastName}");
    } catch (e) {
      isLoading.value = false;
      print(" Error loading user: $e");
    }
  }

  Future<void> refreshUser() async {
    await loadUser();
  }
}
