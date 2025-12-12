import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // ⬅️ أضف هذا الاستيراد

class LocalStorageService {
  static final GetStorage _storage = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  // حفظ صورة كـ base64
  static Future<String?> saveImageAsBase64(String key, XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      await _storage.write(key, base64Image);
      return base64Image;
    } catch (e) {
      print("Error saving image as base64: $e");
      return null;
    }
  }

  // حفظ صورة كـ bytes مباشرة
  static Future<void> saveImageBytes(String key, XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      await _storage.write(key + '_bytes', bytes);
      // حفظ المسار أيضاً
      await _storage.write(key + '_path', image.path);
    } catch (e) {
      print("Error saving image bytes: $e");
    }
  }

  // جلب الصورة المحفوظة
  static Uint8List? getImageBytes(String key) {
    final data = _storage.read(key + '_bytes');
    if (data == null) return null;

    // تحويل List<int> إلى Uint8List
    if (data is List<int>) {
      return Uint8List.fromList(data);
    } else if (data is List) {
      // تحويل عام لأي نوع List
      return Uint8List.fromList(data.cast<int>());
    }
    return null;
  }

  static String? getImagePath(String key) {
    return _storage.read(key + '_path');
  }

  static String? getImageBase64(String key) {
    return _storage.read(key);
  }

  // مسح الصورة
  static void removeImage(String key) {
    _storage.remove(key);
    _storage.remove(key + '_bytes');
    _storage.remove(key + '_path');
  }

  // دالة مساعدة لتحويل base64 إلى Uint8List
  static Uint8List? base64ToBytes(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      print("Error converting base64 to bytes: $e");
      return null;
    }
  }
}
