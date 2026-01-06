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
  final String? initialStartDate;
  final int? initialDuration;

  BookingDatePage({
    super.key,
    required this.houseId,
    required this.rentValue,
    this.initialStartDate,
    this.initialDuration,
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
    // 🔽 نضبط البيانات الأولية إذا موجودة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialStartDate != null) {
        controller.selectedStartDate.value = DateTime.parse(initialStartDate!);
      }
      if (initialDuration != null) {
        controller.duration.value = initialDuration!;
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        iconTheme:  IconThemeData(color:Theme.of(context).colorScheme.onPrimary),
        title:  Text(
          "Select Booking Date".tr,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
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
                          key: ValueKey(controller.reservations.length),

                          firstDay: DateTime.now(),
                          lastDay: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          focusedDay: DateTime.now(),

                          calendarFormat: CalendarFormat.month,
                          availableCalendarFormats:  {
                            CalendarFormat.month: 'Month'.tr,
                          },
                          selectedDayPredicate: (day) => isSameDay(
                            controller.selectedStartDate.value,
                            day,
                          ),
                          onDaySelected: (day, _) {
                            if (controller.isDayBooked(day))
                              return; // يمنع الاختيار
                            controller.selectedStartDate.value = day;
                          },
                          calendarBuilders: CalendarBuilders(
                            prioritizedBuilder: (context, day, _) {
                              /// 🔴 محجوز (له الأولوية القصوى)
                              if (controller.isDayBooked(day)) {
                                return _circleDay(
                                  day,
                                  Colors.red.shade400,
                                  Theme.of(context).colorScheme.surface,
                                );
                              }

                              /// 🔵 بداية الحجز
                              if (controller.isStartDay(day)) {
                                return _circleDay(
                                  day,
                                  Theme.of(context).colorScheme.onPrimary,
                                  Theme.of(context).colorScheme.surface,
                                );
                              }

                              /// 🔵 نهاية الحجز
                              if (controller.isEndDay(day)) {
                                return _circleDay(
                                  day,
                                  Theme.of(context).colorScheme.onPrimary,
                                  Theme.of(context).colorScheme.surface,
                                );
                              }

                              /// 🔹 داخل الفترة
                              if (controller.isInSelectedRange(day)) {
                                return _circleDay(
                                  day,
                                  Theme.of(context).colorScheme.onPrimary,
                                  Colors.black,
                                );
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
                                context: context,
                                Icons.login,
                                "CHECK IN".tr,
                                controller.selectedStartDate.value,
                              ),
                              const Spacer(),
                              _dateInfo(
                                context: context,
                                Icons.logout,
                                "CHECK OUT".tr,
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
                               Text(
                                "Duration (Months)".tr,
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
                                    selected: controller.duration.value == m,
                                    selectedColor: Theme.of(context).colorScheme.onPrimary,
                                    labelStyle: TextStyle(
                                      color: controller.duration.value == m
                                          ? Theme.of(context).colorScheme.surface
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
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
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
                        "Unavailable".tr,
                        "Selected period conflicts with existing bookings".tr,
                        backgroundColor: Colors.red,
                        colorText: Theme.of(context).colorScheme.surface,
                      );
                    }
                  },
                  child:  Text(
                    "Next".tr,
                    style: TextStyle(fontSize: 16, color:Theme.of(context).colorScheme.surface),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateInfo(IconData icon, String title, DateTime? date ,{required BuildContext context,}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          date == null ? "--" : DateFormat('MMM dd, yyyy'.tr).format(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _circleDay(DateTime day, Color bg, Color textColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
