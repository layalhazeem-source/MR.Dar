import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
RxString role = ''.obs;

bool get isOwner => role.value == 'owner';
bool get isRenter => role.value == 'renter';
bool get isAdmin => role.value == 'admin';

bool get hasValidRole => isOwner || isRenter || isAdmin;
@override
void onInit() {
  super.onInit();
  loadUserRole();
}

Future<void> loadUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  role.value = prefs.getString('role') ?? '';
}

void setRole(String newRole) {
  role.value = newRole;
  update();
}
}

