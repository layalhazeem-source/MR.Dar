import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/booking_model.dart';
import '../service/booking_service.dart';

class BookingController extends GetxController {
  final BookingService service;
  final int houseId;
  final double rentValue;

  BookingController({
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
    return DateTime(
      start.year,
      start.month + duration.value,
      start.day,
    );
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
