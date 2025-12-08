import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class MyAccountController extends GetxController {
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    user.value = UserModel.fromPrefs({
      "id": prefs.getString("id") ?? "",
      "first_name": prefs.getString("first_name") ?? "",
      "last_name": prefs.getString("last_name") ?? "",
      "phone": prefs.getString("phone") ?? "",
      "role": prefs.getString("role") ?? "",
      "date_of_birth": prefs.getString("date_of_birth") ?? "",
    });
  }
}
