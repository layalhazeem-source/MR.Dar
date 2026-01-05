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
    const primary = Color(0xFF6FA8DC); // أزرق هادئ ومريح
    const bg = Color(0xFF0E1625);      // خلفية رئيسية
    const surface = Color(0xFF162033); // كروت / عناصر
    const textPrimary = Color(0xFFE6EDF5); // أبيض مكسور
    const textSecondary = Color(0xFF9FB2C8);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: bg,

      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        foregroundColor: textPrimary,
        iconTheme: IconThemeData(color: textPrimary),
      ),

      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: Color(0xFF9CC4E4),
        background: bg,
        surface: surface,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: textPrimary,
        onSurface: textPrimary,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(color: textSecondary),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
      ),
    );
  }
}
