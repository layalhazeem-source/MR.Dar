import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  RxString role = ''.obs;

  // الأدوار المختلفة
  bool get isOwner => role.value == 'owner' || role.value == '3';
  bool get isRenter => role.value == 'renter' || role.value == '2';
  bool get isAdmin => role.value == 'admin' || role.value == '1';
 // bool get isGuest => role.value.isEmpty || role.value == 'guest';

  // دالة للتحقق إذا كان لديه دور صالح
  bool get hasValidRole => isOwner || isRenter || isAdmin;

  Future<void> loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedRole = prefs.getString('role');


    if (savedRole == '3' || savedRole == 'owner') {
      role.value = 'owner';
    } else if (savedRole == '2' || savedRole == 'renter') {
      role.value = 'renter';
    } else if (savedRole == '1' || savedRole == 'admin') {
      role.value = 'admin';
    }
    // else {
    //   role.value = savedRole ?? 'guest';
    // }
  }

  // دالة لتعيين الدور
  void setRole(String newRole) {
    role.value = newRole;
    update();
  }
}