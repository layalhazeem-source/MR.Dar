import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homecontroller.dart';
import '../controller/my_rents_controller.dart';
import '../controller/notification_controller.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Notifications".tr,
          style: Theme.of(context).textTheme.titleLarge,),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return  Center(child: Text("No notifications yet".tr));
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final n = controller.notifications[index];

            return GestureDetector(
              onTap: () {
                final homeController = Get.find<HomeController>();
                final myRentsController = Get.find<MyRentsController>();

                // 1️⃣ روح على My Rents
                homeController.changeTab(1);

                // 2️⃣ مرّري الحالة والـ id
                myRentsController.handleNotification(
                  status: n.status,
                  reservationId: n.reservationId,
                );

                // 3️⃣ سكّري صفحة الإشعارات
                Get.back();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔵 أيقونة الحالة
                    Icon(
                      getStatusIcon(n.status),
                      color: getStatusColor(n.status),
                      size: 28,
                    ),
                    const SizedBox(width: 12),

                    // 📄 محتوى الإشعار
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 العنوان + الوقت
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  n.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              if (n.time != null)
                                Text(
                                  n.time!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          // 🏠 اسم الشقة
                          if (n.house != null)
                            Text(
                              n.house!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          const SizedBox(height: 4),

                          // 📝 الرسالة
                          Text(
                            n.message,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // 📅 التاريخ
                          if (n.date != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 13,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  n.date!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );


          },
        );
      }),
    );
  }
}
IconData getStatusIcon(String status) {
  switch (status) {
    case 'accepted':
      return Icons.check_circle;
    case 'pending':
      return Icons.hourglass_top;
    case 'rejected':
      return Icons.cancel;
    case 'blocked':
      return Icons.block;
    case 'canceled':
      return Icons.remove_circle;
    default:
      return Icons.notifications;
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'accepted':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'rejected':
      return Colors.red;
    case 'blocked':
      return Colors.grey.shade700;
    case 'canceled':
      return Colors.red.shade700;
    default:
      return Colors.blueGrey;
  }
}
