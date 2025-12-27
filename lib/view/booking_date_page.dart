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
      appBar: AppBar(title: const Text("Select Dates")),
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
                  defaultBuilder: (context, day, focusedDay) {
                    // تظليل الأيام المحجوزة
                    if (controller.isDayBooked(day)) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "${day.day}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }

                    // تظليل الفترة المختارة (من تاريخ البداية + المدة)
                    if (controller.selectedStartDate.value != null) {
                      final startDate = controller.selectedStartDate.value!;
                      final endDate = controller.endDate;

                      if (endDate != null &&
                          !isSameDay(day, startDate) &&
                          !isSameDay(day, endDate) &&
                          day.isAfter(startDate) &&
                          day.isBefore(endDate)) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF274668).withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${day.day}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }

                      // تظليل تاريخ النهاية
                      if (endDate != null && isSameDay(day, endDate)) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF274668),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${day.day}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        color: Color(0xFF274668),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
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
            _durationChips(controller),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: controller.selectedStartDate.value == null
                    ? null
                    : () => Get.to(
                      () => BookingConfirmPage(),
                  arguments: houseId.toString(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF274668),


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

  Widget _durationChips(BookingController controller) {
    final months = [1, 2, 3, 6];

    return Wrap(
      spacing: 10,
      children: months.map((m) {
        final selected = controller.duration.value == m;
        return ChoiceChip(
          label: Text("$m Month${m > 1 ? 's' : ''}"),
          selected: selected,
          selectedColor: const Color(0xFF274668),
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
          onSelected: (_) => controller.duration.value = m,
        );
      }).toList(),
    );
  }
}
