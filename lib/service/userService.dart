import '../core/api/dio_consumer.dart';
import '../core/api/end_points.dart';
import '../model/user_model.dart';

class UserService {
  final DioConsumer api;
  UserService(this.api);

  Future<UserModel> getProfile() async {
    print("📞 [USER SERVICE] Calling getProfile API...");
    try {
      final response = await api.get(EndPoint.getAccount);
      print("✅ [USER SERVICE] API Response received");
      print("📊 [USER SERVICE] Response type: ${response.runtimeType}");
      print("🔍 [USER SERVICE] Response data: $response");

      if (response is Map && response.containsKey('data')) {
        print("🎯 [USER SERVICE] Data key exists");
        return UserModel.fromJson(response['data']);
      } else {
        print("❌ [USER SERVICE] No 'data' key in response");
        throw Exception("Invalid API response format");
      }
    } catch (e, s) {
      print("💥 [USER SERVICE] Error getting profile: $e");
      print("📋 [USER SERVICE] Stack trace: $s");
      rethrow;
    }
  }

  Future<void> logout() async {
    await api.post(EndPoint.logout);
  }

  Future<void> deleteAccount() async {
    await api.delete(EndPoint.deleteAccount);
  }
}
