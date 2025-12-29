// lib/core/theme/theme_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  static const _key = 'isDarkMode';
  final GetStorage _box;

  // Rx -> لنقدر نستخدم Obx لتحديث الأيقونة فوراً
  final RxBool _isDark = false.obs;

  ThemeService(this._box) {
    // عند الإنشاء نحمّل القيمة المخزنة
    _isDark.value = _box.read(_key) ?? false;
  }

  // getter للسمة الحالية
  bool get isDarkMode => _isDark.value;

  // Stream / observable لو حبيت تراقب
  RxBool get rxIsDark => _isDark;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Toggle مع حفظ القيمة
  void toggleTheme() {
    final newVal = !_isDark.value;
    _isDark.value = newVal;
    _box.write(_key, newVal);
    // يغير ثيم التطبيق فوراً
    Get.changeThemeMode(newVal ? ThemeMode.dark : ThemeMode.light);
  }

  // تعطي ThemeData جاهزين — عدلي القيم حسب ذوقك
  ThemeData get lightTheme {
    const primaryColor = Color(0xFF274668); // كحلي
    const textColor = Color(0xFF274668); // نفس الكحلي للنصوص
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white, // الخلفية الرئيسية
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, // أبيض
        elevation: 0,
        foregroundColor: primaryColor, // كتابة الكحلي
        iconTheme: IconThemeData(color: primaryColor), // أيقونات الكحلي
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor, // لون رئيسي
        secondary: Color(0xFF274668), // لون ثانوي
        background: Colors.white, // خلفية عامة
        surface: Colors.white, // خلفية عناصر مثل البطاقات
        onPrimary: Colors.white, // نص على العناصر المختارة
        onSecondary: Colors.white,
        onBackground: primaryColor, // نصوص عامة
        onSurface: primaryColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5), // خلفية الحقول فاتحة
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // لون الزر الأساسي
          foregroundColor: Colors.white, // كتابة الزر بيضاء
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor, // العنصر المختار كحلي
        unselectedItemColor: primaryColor.withOpacity(0.5), // العناصر العادية فاتحة شوي
      ), checkboxTheme: CheckboxThemeData(
 fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return primaryColor; }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return primaryColor; }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return primaryColor; }
 return null;
 }),
 trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return primaryColor; }
 return null;
 }),
 ), // مثل Checkbox & Switch
    );
  }


  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF274668),
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF12233A),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF274668),
        secondary: const Color(0xFF96C6E2),
        background: const Color(0xFF0B1220),
        surface: const Color(0xFF0F1724),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1F2937),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF274668),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
