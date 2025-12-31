import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/booking_controller.dart';

class BookingConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>(
      tag: Get.arguments,
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF274668),
        ),
        title:  Text(
          "Confirm BookingConfirm Booking".tr,
          style: TextStyle(
            color: Color(0xFF274668),
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
                Icons.location_on,
                "${controller.apartment.cityName} - ${controller.apartment.governorateName}"
                , // ⛔ مؤقت
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
                    Icons.login,
                    DateFormat('MMM dd, yyyy'.tr)
                        .format(controller.selectedStartDate.value!),
                  ),
                  const SizedBox(height: 12),
                  _row(
                    Icons.logout,
                    DateFormat('MMM dd, yyyy'.tr)
                        .format(controller.endDate!),
                  ),
                  const Divider(height: 30),
                  _row(
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
                  _row(
                    Icons.payments,
                    "Cash".tr,
                  ),
                  const Divider(height: 30),
                  _row(
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
                    backgroundColor: const Color(0xFF274668),
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
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      :  Text(
                    "Confirm Booking".tr,
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  /// ===== Row =====
  Widget _row(IconData icon, String value,
      {bool bold = false, bool big = false}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF274668)),
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
