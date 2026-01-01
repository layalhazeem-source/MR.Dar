import 'package:get/get.dart';
import '../model/notification_model.dart';
import '../service/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService service;
  NotificationController({required this.service});

  final notifications = <AppNotification>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final data = await service.getNotifications();

      notifications.value = data
          .map((e) => AppNotification.fromJson(e['data']))
          .toList();
    } finally {
      isLoading.value = false;
    }
  }
}
