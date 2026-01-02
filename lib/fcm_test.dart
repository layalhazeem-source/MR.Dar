import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
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

  // 3️⃣ هون الشغل المهم 🔥
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("🔥 New notification arrived");

    // لما يوصل إشعار → نحدّث الإشعارات من الباك
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications();
    }
  });
}
