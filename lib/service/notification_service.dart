import '../core/api/dio_consumer.dart';

class NotificationService {
  final DioConsumer api;
  NotificationService({required this.api});

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await api.get('notifications');

    return List<Map<String, dynamic>>.from(response['data']);
  }
}
