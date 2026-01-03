import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:new_project/service/local_notification_service.dart';
import '../controller/notification_controller.dart';

Future<void> initFcm() async {
  final messaging = FirebaseMessaging.instance;

  // 1️⃣ طلب الإذن
  await messaging.requestPermission();

  // 2️⃣ جلب التوكن
  final token = await messaging.getToken();
  print("FCM TOKEN: $token");

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("NEW TOKEN: $newToken");
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    // 🔔 هذا اللي بيخلّي الإشعار يطلع على الشاشة
    LocalNotificationService.show(
      title: title,
      body: body,
    );

    // 🔄 تحديث الليست داخل التطبيق
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications();
    }
  });

}
