import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../controller/booking_controller.dart';
import '../../service/booking_service.dart';
import '../model/apartment_model.dart';
import 'booking_confirm_page.dart';

class BookingDatePage extends StatelessWidget {
  final int houseId;
  final double rentValue;
  final apartment = Get.arguments as Apartment;

   BookingDatePage({
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
    controller.apartment = apartment;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF274668),
        ),
        title: const Text(
          "Select Booking Date",
          style: TextStyle(
            color: Color(0xFF274668),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: Obx(
            () => Column(
          children: [
            /// 🔽 كل المحتوى Scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    /// 📅 Calendar
                    Card(
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay:
                          DateTime.now().add(const Duration(days: 365)),
                          focusedDay: DateTime.now(),
                          calendarFormat: CalendarFormat.month,
                          availableCalendarFormats: const {
                            CalendarFormat.month: 'Month',
                          },
                          selectedDayPredicate: (day) =>
                              isSameDay(
                                  controller.selectedStartDate.value, day),
                          onDaySelected: (day, _) {
                            if (controller.isDayBooked(day)) return;
                            controller.selectedStartDate.value = day;
                          },
                          calendarBuilders: CalendarBuilders(
                            prioritizedBuilder: (context, day, _) {
                              if (controller.isDayBooked(day)) {
                                return _bookedDay(day);
                              }

                              if (controller.selectedStartDate.value != null &&
                                  controller.endDate != null) {
                                final start =
                                controller.selectedStartDate.value!;
                                final end = controller.endDate!;

                                if (isSameDay(day, start) ||
                                    isSameDay(day, end)) {
                                  return _selectedDay(day);
                                }

                                if (day.isAfter(start) &&
                                    day.isBefore(end)) {
                                  return _rangeDay(day);
                                }
                              }
                              return null;
                            },
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                        ),
                      ),
                    ),

                    /// 🗓 Check in / out
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              _dateInfo(
                                Icons.login,
                                "CHECK IN",
                                controller.selectedStartDate.value,
                              ),
                              const Spacer(),
                              _dateInfo(
                                Icons.logout,
                                "CHECK OUT",
                                controller.endDate,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ⏱ Duration
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Duration (Months)",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                children: List.generate(12, (index) {
                                  final m = index + 1;
                                  return ChoiceChip(
                                    label: Text("$m"),
                                    selected:
                                    controller.duration.value == m,
                                    selectedColor:
                                    const Color(0xFF274668),
                                    labelStyle: TextStyle(
                                      color: controller.duration.value == m
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onSelected: (_) =>
                                    controller.duration.value = m,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ▶️ زر ثابت
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF274668),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    if (controller.selectedStartDate.value == null) return;

                    if (controller.isRangeAvailable()) {
                      Get.to(
                            () => BookingConfirmPage(),
                        arguments: houseId.toString(),
                      );
                    } else {
                      Get.snackbar(
                        "Unavailable",
                        "Selected period conflicts with existing bookings",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateInfo(IconData icon, String title, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF274668)),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          date == null
              ? "--"
              : DateFormat('MMM dd, yyyy').format(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _bookedDay(DateTime day) => Container(
    decoration: BoxDecoration(
      color: Colors.red.shade100,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        "${day.day}",
        style: const TextStyle(color: Colors.red),
      ),
    ),
  );

  Widget _selectedDay(DateTime day) => Container(
    decoration: const BoxDecoration(
      color: Color(0xFF274668),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        "${day.day}",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );

  Widget _rangeDay(DateTime day) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFF274668).withOpacity(0.15),
      shape: BoxShape.circle,
    ),
    child: Center(child: Text("${day.day}")),
  );
}
