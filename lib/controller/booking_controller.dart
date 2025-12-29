import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/apartment_model.dart';
import '../model/booking_model.dart';
import '../service/booking_service.dart';

class BookingController extends GetxController {
  final BookingService service;
  final int houseId;
  final double rentValue;
  late Apartment apartment;

  BookingController(
       {
    required this.service,
    required this.houseId,
    required this.rentValue,
  });

  /// بيانات الحجز
  var selectedStartDate = Rxn<DateTime>();
  var duration = 1.obs; // بالشهر
  var isLoading = false.obs;

  /// الحجوزات الحالية
  var reservations = <Booking>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReservations();

  }

  Future<void> loadReservations() async {
    reservations.value = await service.getHouseReservations(houseId);
  }

  /// الأيام المحجوزة (للتقويم)
  List<DateTime> get bookedDays {
    List<DateTime> days = [];

    for (var r in reservations) {
      if (r.status != 'accepted') continue;

      DateTime start = DateTime.parse(r.startDate);
      DateTime end = DateTime.parse(r.endDate);

      for (DateTime d = start;
      d.isBefore(end);
      d = d.add(const Duration(days: 1))) {
        days.add(d);
      }
    }
    return days;
  }
  bool isDayBooked(DateTime day) {
    for (var r in reservations) {
      if (r.status != 'accepted') continue;

      DateTime start = DateTime.parse(r.startDate);
      DateTime end = DateTime.parse(r.endDate);


      if (!day.isBefore(start) && !day.isAfter(end)) {
        return true;
      }
    }
    return false;
  }
  DateTime? get endDate {
    if (selectedStartDate.value == null) return null;

    final start = selectedStartDate.value!;

    // 1. منجرب نحسب التاريخ بإضافة المدة
    DateTime tempEnd = DateTime(start.year, start.month + duration.value, start.day);

    // 2. إذا نط التاريخ لشهر زيادة (يعني اليوم اختلف)
    // منقله لـ Dart: أعطيني آخر يوم بالشهر المطلوب (يوم 0 من الشهر التالي هو آخر يوم بالحالي)
    if (tempEnd.day != start.day) {
      tempEnd = DateTime(tempEnd.year, tempEnd.month, 0);
    }

    return tempEnd;
  }
  bool isRangeAvailable() {
    if (selectedStartDate.value == null || endDate == null) return false;

    DateTime current = selectedStartDate.value!;
    // نمشي يوم يوم من البداية للنهاية ونشوف إذا في يوم محجوز
    while (current.isBefore(endDate!) || isSameDay(current, endDate!)) {
      if (isDayBooked(current)) return false; // لقينا يوم محجوز بالنص!
      current = current.add(const Duration(days: 1));
    }
    return true;
  }
  double get totalPrice => duration.value * rentValue;

  Future<void> confirmBooking() async {
    if (selectedStartDate.value == null) return;

    isLoading.value = true;

    final success = await service.createReservation(
      houseId: houseId,
      startDate: DateFormat('yyyy-MM-dd')
          .format(selectedStartDate.value!),
      duration: duration.value,
    );

    isLoading.value = false;

    if (success) {
      Get.snackbar("Success", "Reservation sent successfully");
      Get.back();
      Get.back();
    } else {
      Get.snackbar("Error", "Failed to create reservation");
    }
  }
}
