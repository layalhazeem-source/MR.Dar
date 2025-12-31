import 'package:flutter/material.dart';
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
  double get totalPrice => duration.value * rentValue;

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
    reservations.refresh(); // 👈 مهم
  }

  /// الأيام المحجوزة (للتقويم)
  List<DateTime> get bookedDays {
    List<DateTime> days = [];

    for (var r in reservations) {
      if (r.status != 'accepted') continue;

      DateTime start = DateTime.parse(r.startDate);
      DateTime end = DateTime.parse(r.endDate);

      for (
        DateTime d = start;
        d.isBefore(end);
        d = d.add(const Duration(days: 1))
      ) {
        days.add(d);
      }
    }
    return days;
  }

  bool isDayBooked(DateTime day) {
    final checkDay = DateTime(day.year, day.month, day.day);

    for (var r in reservations) {
      if (r.status != 'accepted') continue;

      final start = DateTime.parse(r.startDate);
      final end = DateTime.parse(r.endDate);

      final startDay = DateTime(start.year, start.month, start.day);
      final endDay = DateTime(end.year, end.month, end.day);

      // اليوم ضمن الفترة
      if (!checkDay.isBefore(startDay) && !checkDay.isAfter(endDay)) {
        return true;
      }
    }
    return false;
  }

  DateTime? get endDate {
    if (selectedStartDate.value == null) return null;

    final start = selectedStartDate.value!;

    // 1. منجرب نحسب التاريخ بإضافة المدة
    DateTime tempEnd = DateTime(
      start.year,
      start.month + duration.value,
      start.day,
    );

    // 2. إذا نط التاريخ لشهر زيادة (يعني اليوم اختلف)
    // منقله لـ Dart: أعطيني آخر يوم بالشهر المطلوب (يوم 0 من الشهر التالي هو آخر يوم بالحالي)
    if (tempEnd.day != start.day) {
      tempEnd = DateTime(tempEnd.year, tempEnd.month, 0);
    }

    return tempEnd;
  }

  bool isStartDay(DateTime day) {
    if (selectedStartDate.value == null) return false;
    return isSameDay(day, selectedStartDate.value);
  }

  bool isEndDay(DateTime day) {
    if (endDate == null) return false;
    return isSameDay(day, endDate);
  }

  bool isInSelectedRange(DateTime day) {
    if (selectedStartDate.value == null || endDate == null) return false;

    final d = DateTime(day.year, day.month, day.day);
    final start = DateTime(
      selectedStartDate.value!.year,
      selectedStartDate.value!.month,
      selectedStartDate.value!.day,
    );
    final end = DateTime(endDate!.year, endDate!.month, endDate!.day);

    return d.isAfter(start) && d.isBefore(end);
  }

  // دالة لمعرفة حالة اليوم بدقة
  int getDayStatus(DateTime day) {
    bool hasPending = false;

    for (var r in reservations) {
      DateTime start = DateTime.parse(r.startDate);
      DateTime end = DateTime.parse(r.endDate);

      if (!day.isBefore(start) && !day.isAfter(end)) {
        if (r.status == 'accepted') return 2; // مؤكد -> أحمر مباشرة
        if (r.status == 'pending')
          hasPending = true; // مؤقتاً إذا وجدت حالة معلقة
      }
    }

    return hasPending ? 1 : 0; // إذا لا يوجد تأكيد فقط، نرجع Pending أو متاح
  }

  // المنطق الجديد لفحص توفر الفترة قبل الإرسال
  bool isRangeAvailable() {
    if (selectedStartDate.value == null || endDate == null) return false;

    DateTime current = selectedStartDate.value!;

    while (current.isBefore(endDate!)) {
      if (isDayBooked(current)) return false;
      current = current.add(const Duration(days: 1));
    }
    return true;
  }

  Future<void> confirmBooking() async {
    if (selectedStartDate.value == null) return;

    // حالة (أ): الفحص المحلي قبل الإرسال (تضارب مع حجز مقبول نهائياً)

    isLoading.value = true;
    final success = await service.createReservation(
      houseId: houseId,
      startDate: DateFormat('yyyy-MM-dd').format(selectedStartDate.value!),
      duration: duration.value,
    );
    isLoading.value = false;

    if (success) {
      // حالة (ب): نجاح (سواء كان التاريخ فارغاً أو عليه طلبات Pending لغيرك)
      Get.snackbar(
        "Success",
        "Your reservation request has been sent",
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
      _showResultDialog(
        title: "Booking Sent",
        message:
            "Your request is pending. The owner can now see it and choose to accept it.",
        type: 1, // نجاح
      );
    } else {
      // حالة (ج): فشل من السيرفر (غالباً لأن المستخدم لديه طلب Pending مسبق لنفس البيت)
      Get.snackbar(
        "Duplicate Request",
        "You already have a pending request for this house.",
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        icon: const Icon(Icons.warning, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
      );
      _showResultDialog(
        title: "Request Exists",
        message:
            "You have already sent a request for this house. Please wait for the owner's response.",
        type: 2, // تنبيه
      );
    }
  }

  /// 6. الديالوغ الموحد للألوان الثلاثة
  void _showResultDialog({
    required String title,
    required String message,
    required int type, // 0: فشل، 1: نجاح، 2: تنبيه
  }) {
    Color mainColor;
    IconData mainIcon;
    String buttonText;

    switch (type) {
      case 1:
        mainColor = Colors.green;
        mainIcon = Icons.check_circle;
        buttonText = "Great!";
        break;
      case 2:
        mainColor = Colors.orange;
        mainIcon = Icons.warning_amber_rounded;
        buttonText = "I Understand";
        break;
      default:
        mainColor = Colors.red;
        mainIcon = Icons.error_outline;
        buttonText = "Try Again";
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(mainIcon, color: mainColor, size: 64),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Get.back(); // إغلاق الديالوغ
                if (type == 1) {
                  Get.back(); // العودة من صفحة التأكيد
                  Get.back(); // العودة من صفحة التاريخ
                }
              },
              child: Text(
                buttonText,
                style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
