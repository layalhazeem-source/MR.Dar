import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../controller/booking_controller.dart';
import '../../service/booking_service.dart';
import 'booking_confirm_page.dart';

class BookingDatePage extends StatelessWidget {
  final int houseId;
  final double rentValue;

  const BookingDatePage({
    super.key,
    required this.houseId,
    required this.rentValue,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      BookingController(
        service: Get.find<BookingService>(),
        houseId: houseId,
        rentValue: rentValue,

      ),
      tag: houseId.toString(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Select Dates"),backgroundColor: Color(0xFF274668),),
      body: Obx(
            () => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: TableCalendar(
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: DateTime.now(),
                selectedDayPredicate: (day) {
                  // Highlight only start date
                  return isSameDay(controller.selectedStartDate.value, day);
                },
                onDaySelected: (selected, _) {
                  if (controller.isDayBooked(selected)) return;

                  // فقط اختيار تاريخ البداية
                  controller.selectedStartDate.value = selected;
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: const Color(0xFF274668),
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  // استخدمي prioritizedBuilder بدلاً من defaultBuilder لضمان أن التصميم يطبق فوق الستايل الافتراضي
                  prioritizedBuilder: (context, day, focusedDay) {
                    // 1. تظليل الأيام المحجوزة باللون الأحمر (Unavailable)
                    if (controller.isDayBooked(day)) {
                      return Container(
                        margin: const EdgeInsets.all(4), // ترك مسافة بسيطة بين الدوائر
                        decoration: BoxDecoration(
                          color: Colors.red.shade50, // خلفية حمراء فاتحة جداً
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red.shade200, width: 1), // إطار أحمر خفيف
                        ),
                        child: Center(
                          child: Text(
                            "${day.day}",
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.lineThrough, // خط فوق الرقم ليوحي بأنه غير متاح
                            ),
                          ),
                        ),
                      );
                    }

                    // 2. تظليل الفترة المختارة (كما هي مع تحسين بسيط)
                    if (controller.selectedStartDate.value != null && controller.endDate != null) {
                      final startDate = controller.selectedStartDate.value!;
                      final endDate = controller.endDate!;

                      // تاريخ البداية
                      if (isSameDay(day, startDate)) {
                        return Container(
                          decoration: const BoxDecoration(color: Color(0xFF274668), shape: BoxShape.circle),
                          child: Center(child: Text("${day.day}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        );
                      }

                      // تاريخ النهاية
                      if (isSameDay(day, endDate)) {
                        return Container(
                          decoration: const BoxDecoration(color: Color(0xFF274668), shape: BoxShape.circle),
                          child: Center(child: Text("${day.day}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        );
                      }

                      // الأيام الوسطى
                      if (day.isAfter(startDate) && day.isBefore(endDate)) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF274668).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text("${day.day}", style: const TextStyle(color: Color(0xFF274668), fontWeight: FontWeight.bold))),
                        );
                      }
                    }
                    return null;
                  },
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  leftChevronIcon: const Icon(Icons.chevron_left),
                  rightChevronIcon: const Icon(Icons.chevron_right),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.grey.shade600),
                  weekendStyle: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(Colors.red.shade300, "Booked"),
                  const SizedBox(width: 20),
                  _buildLegendItem(const Color(0xFF274668), "Selected"),
                ],
              ),
            ),
            // Check In / Check Out Section with Arrow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _dateBox("CHECK IN", controller.selectedStartDate.value),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF274668),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _dateBox("CHECK OUT", controller.endDate),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    "Duration (months): ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                        () => DropdownButton<int>(
                      value: controller.duration.value,
                      items: List.generate(12, (index) => index + 1)
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("$e"),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.duration.value = value;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                  onPressed: () {
                    if (controller.selectedStartDate.value == null) return;

                    if (controller.isRangeAvailable()) {
                      Get.to(() => BookingConfirmPage(), arguments: houseId.toString());
                    } else {
                      Get.snackbar(
                        "Sorry",
                        "The selected period conflicts with existing bookings",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF274668),
                  foregroundColor: Colors.white, // النص يكون أبيض دائمًا
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
              ),
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateBox(String title, DateTime? date) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              date == null
                  ? "--"
                  : DateFormat('MMM dd, yyyy').format(date),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
