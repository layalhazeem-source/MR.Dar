import '../core/api/dio_consumer.dart';
import '../core/api/end_points.dart';
import '../model/user_model.dart';

class UserService {
  final DioConsumer api;
  UserService(this.api);

  Future<UserModel> getProfile() async {
    final response = await api.get(EndPoint.getAccount);
    return UserModel.fromJson(response["data"]);
  }

  Future<void> logout() async {
    await api.post(EndPoint.logout);
  }

  Future<void> deleteAccount() async {
    await api.delete(EndPoint.deleteAccount);
  }
}
