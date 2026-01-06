import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/booking_controller.dart';

class BookingConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>(tag: Get.arguments);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text(
          "Confirm Booking".tr,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 📍 Location Card
            _infoCard(
              title: "Location".tr,
              child: _row(
                context,
                Icons.location_on,
                "${controller.apartment.cityName} - ${controller.apartment.governorateName}", // ⛔ مؤقت
                bold: true,
              ),
            ),

            const SizedBox(height: 16),

            /// 📅 Period & Duration
            _infoCard(
              title: "Booking Period".tr,
              child: Column(
                children: [
                  _row(
                    context,
                    Icons.login,
                    DateFormat(
                      'MMM dd, yyyy'.tr,
                    ).format(controller.selectedStartDate.value!),
                  ),
                  const SizedBox(height: 12),
                  _row(
                    context,
                    Icons.logout,
                    DateFormat('MMM dd, yyyy'.tr).format(controller.endDate!),
                  ),
                  const Divider(height: 30),
                  _row(
                    context,
                    Icons.timelapse,
                    "${controller.duration.value} month(s)".tr,
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 💳 Payment & Price
            _infoCard(
              title: "Payment".tr,
              child: Column(
                children: [
                  _row(context, Icons.payments, "Cash".tr),
                  const Divider(height: 30),
                  _row(
                    context,
                    Icons.attach_money,
                    "\$${controller.totalPrice}",
                    bold: true,
                    big: true,
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// ✅ Confirm Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          await controller.confirmBooking();
                        },
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Confirm Booking".tr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== Card Wrapper =====
  Widget _infoCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  /// ===== Row =====
  Widget _row(
    BuildContext context,
    IconData icon,
    String value, {
    bool bold = false,
    bool big = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: big ? 20 : 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
