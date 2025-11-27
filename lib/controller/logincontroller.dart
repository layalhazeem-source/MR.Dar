import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class loginController extends GetxController {
  var isPasswordHidden = true; // حالة الإخفاء

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    update(); // تحديث الواجهة
  }
}
