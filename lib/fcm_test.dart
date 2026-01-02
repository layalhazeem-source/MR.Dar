import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> initFcm() async {
  final messaging = FirebaseMessaging.instance;

  // طلب صلاحية الإشعارات (مهم لـ Android 13 و iOS)
  await messaging.requestPermission();

  final token = await messaging.getToken();
  print("FCM TOKEN: $token");

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("NEW TOKEN: $newToken");
  });
}
