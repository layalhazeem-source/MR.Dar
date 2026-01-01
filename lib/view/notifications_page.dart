import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/notification_controller.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text("No notifications yet"));
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final n = controller.notifications[index];

            return ListTile(
              leading: Icon(
                n.status == "accepted"
                    ? Icons.check_circle
                    : Icons.cancel,
                color: n.status == "accepted"
                    ? Colors.green
                    : Colors.red,
              ),
              title: Text(n.title),
              subtitle: Text(n.message),
            );
          },
        );
      }),
    );
  }
}
