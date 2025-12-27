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
      appBar: AppBar(title: const Text("Confirm Booking"),backgroundColor: Color(0xFF274668),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(
                      () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row("Check-in",
                          DateFormat('MMM dd, yyyy')
                              .format(controller.selectedStartDate.value!)),
                      _row("Check-out",
                          DateFormat('MMM dd, yyyy')
                              .format(controller.endDate!)),
                      _row("Duration",
                          "${controller.duration.value} month(s)"),
                      const Divider(),
                      _row("Total price ",
                          "\$${controller.totalPrice}",
                          bold: true),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF274668),
                      foregroundColor: Colors.white, // النص يكون أبيض دائمًا
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                onPressed: controller.isLoading.value
                    ? null
                    : controller.confirmBooking,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Confirm Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
