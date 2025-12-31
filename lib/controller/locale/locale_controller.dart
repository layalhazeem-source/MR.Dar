// lib/controller/locale/locale_controller.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  final _storage = GetStorage();
  final String _localeKey = 'app_locale';

  // القيمة الافتراضية
  RxString currentLocale = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    // جلب اللغة المحفوظة عند بدء التطبيق
    final savedLocale = _storage.read(_localeKey);
    if (savedLocale != null) {
      currentLocale.value = savedLocale;
      Get.updateLocale(Locale(savedLocale));
    }
  }

  // تغيير اللغة
  void changeLocale(String newLocale) {
    currentLocale.value = newLocale;
    Get.updateLocale(Locale(newLocale));
    _storage.write(_localeKey, newLocale); // حفظ في التخزين المحلي
  }

  // تبديل بين العربية والإنجليزية
  void toggleLocale() {
    if (currentLocale.value == 'ar') {
      changeLocale('en');
    } else {
      changeLocale('ar');
    }
  }
}