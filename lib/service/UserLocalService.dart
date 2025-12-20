import 'package:shared_preferences/shared_preferences.dart';

class UserLocalService {
  static const String _keyToken = 'token';
  static const String _keyId = 'id';
  static const String _keyFirstName = 'first_name';
  static const String _keyLastName = 'last_name';
  static const String _keyPhone = 'phone';
  static const String _keyRole = 'role';
  static const String _keyBirthDate = 'date_of_birth';
  static const String _keyProfileImage = 'profile_image';
  static const String _keyIdImage = 'id_image';

  Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    if (data['token'] != null) {
      await prefs.setString(_keyToken, data['token']);
    }
    if (data['id'] != null) {
      await prefs.setString(_keyId, data['id'].toString());
    }
    if (data['first_name'] != null) {
      await prefs.setString(_keyFirstName, data['first_name']);
    }
    if (data['last_name'] != null) {
      await prefs.setString(_keyLastName, data['last_name']);
    }
    if (data['phone'] != null) {
      await prefs.setString(_keyPhone, data['phone']);
    }
    if (data['role'] != null) {
      await prefs.setString(_keyRole, data['role']);
    }
    if (data['date_of_birth'] != null) {
      await prefs.setString(_keyBirthDate, data['date_of_birth']);
    }
    if (data['profile_image'] != null &&
        data['profile_image'].toString().isNotEmpty) {
      await prefs.setString(_keyProfileImage, data['profile_image'].toString());
    }
    if (data['id_image'] != null && data['id_image'].toString().isNotEmpty) {
      await prefs.setString(_keyIdImage, data['id_image'].toString());
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'token': prefs.getString(_keyToken),
      'id': prefs.getString(_keyId),
      'first_name': prefs.getString(_keyFirstName),
      'last_name': prefs.getString(_keyLastName),
      'phone': prefs.getString(_keyPhone),
      'role': prefs.getString(_keyRole),
      'date_of_birth': prefs.getString(_keyBirthDate),
      'profile_image': prefs.getString(_keyProfileImage),
      'id_image': prefs.getString(_keyIdImage),
    };
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyId);
    await prefs.remove(_keyFirstName);
    await prefs.remove(_keyLastName);
    await prefs.remove(_keyPhone);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyBirthDate);
    await prefs.remove(_keyProfileImage);
    await prefs.remove(_keyIdImage);
  }

  Future<bool> hasUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken) != null;
  }
}
