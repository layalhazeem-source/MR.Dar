import 'package:get/get.dart';

class signupController extends GetxController {
  var birthDate = "".obs; // observable string لتخزين التاريخ

  void setBirthDate(String date) {
    birthDate.value = date;
  }
}
