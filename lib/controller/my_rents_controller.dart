import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/enums/reservation_status.dart'
    show ReservationStatus, ReservationStatusExtension;
import '../model/reservation_model.dart';
import '../service/booking_service.dart';
import '../view/booking_date_page.dart';

class MyRentsController extends GetxController {
  final BookingService bookingService;

  MyRentsController({required this.bookingService});

  // جميع الحجوزات
  final RxList<ReservationModel> allReservations = <ReservationModel>[].obs;
  // الحالة الحالية
  final Rx<ReservationStatus> currentStatus = ReservationStatus.pending.obs;
  //حالات الواجهة
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isProcessing = false.obs; // للعمليات الجديدة
  final highlightedReservationId = RxnInt();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    print('و🔥 MyRentsController INIT ${hashCode}');
    fetchMyReservations();


  }
  // 👈 هاي الدالة بس
  void handleNotification({
    required String status,
    required int reservationId,
  }) {
    currentStatus.value =
        ReservationStatusExtension.fromString(status);

    highlightedReservationId.value = reservationId;
  }

  void scrollToReservation(int reservationId) {
    final index = filteredReservations
        .indexWhere((r) => r.id == reservationId);

    if (index == -1) return;

    scrollController.animateTo(
      index * 170, // حسب ارتفاع الكارد
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// جلب الحجوزات من السيرفر
  Future<void> fetchMyReservations() async {
    print("🟡 fetchMyReservations START");

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final reservations = await bookingService.getMyReservations();

      print("🟢 API returned: ${reservations.length}");

      allReservations.assignAll(reservations);

      print("🟢 allReservations now: ${allReservations.length}");
    } catch (e) {
      print("🔴 ERROR: $e");
      errorMessage.value = 'load reservation failed';
    } finally {
      isLoading.value = false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final reservations = await bookingService.getMyReservations();
      print('🧾 reservations count = ${reservations.length}');
      print("🟢 fetched reservations: ${reservations.length}");
      allReservations.assignAll(reservations);
    } catch (e) {
      errorMessage.value = 'load reservation failed';
    } finally {
      isLoading.value = false;
    }
  }

  // تغيير الحالة (عند الضغط على Tab / Button)
  void changeStatus(ReservationStatus status) {
    currentStatus.value = status;
  }

  /// تحويل status النصي إلى enum
  ReservationStatus _mapStatus(String status) {
    return ReservationStatusExtension.fromString(status);
  }

  /// الحجوزات المفلترة
  List<ReservationModel> get filteredReservations {
    final now = DateTime.now();

    return allReservations.where((reservation) {
      final status = _mapStatus(reservation.status);

      final start = DateTime.parse(reservation.startDate);
      final end = DateTime.parse(reservation.endDate);

      // 🟢 حجز حالي (accepted + ضمن المدة)
      if (currentStatus.value == ReservationStatus.accepted) {
        return status == ReservationStatus.accepted &&
            start.isBefore(now) &&
            end.isAfter(now);
      }

      // 🔵 حجز سابق (انتهى)
      if (currentStatus.value == ReservationStatus.previous) {
        return end.isBefore(now);
      }

      // باقي الحالات
      return status == currentStatus.value;
    }).toList();
  }

  /// تحميل الحجوزات (API)
  void setReservations(List<ReservationModel> reservations) {
    allReservations.assignAll(reservations);
  }

  /// تفريغ البيانات (اختياري)
  void clearReservations() {
    allReservations.clear();
  }

  /// إلغاء حجز
  Future<void> cancelReservation(int reservationId) async {
    try {
      isProcessing.value = true;

      final success = await bookingService.cancelReservation(reservationId);

      if (success) {
        // تحديث حالة الحجز محلياً
        final index = allReservations.indexWhere((r) => r.id == reservationId);
        if (index != -1) {
          allReservations[index] = allReservations[index].copyWith(
            status: 'canceled',
          );
          allReservations.refresh(); // لتحديث الـ Obx
        }

        Get.snackbar(
          "Success",
          "Reservation cancelled successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception("Failed to cancel reservation");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to cancel reservation: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// تعديل حجز (يلغي القديم وينتقل لصفحة الحجز)
  void editReservation(ReservationModel reservation) {
    // 1. نسأل المستخدم إذا مؤكد
    Get.defaultDialog(
      title: "Edit Reservation",
      middleText:
          "Editing will cancel the current request and create a new one. Continue?",
      textConfirm: "Yes, Edit",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF274668),
      onConfirm: () async {
        Get.back();

        // 2. نلغي الحجز القديم
        await cancelReservation(reservation.id);

        // 3. ننتقل لصفحة الحجز مع بيانات الفترة القديمة
        // هون رح نحتاج نمرر بيانات الفترة القديمة
        Get.to(
          () => BookingDatePage(
            houseId: reservation.apartment.id,
            rentValue: reservation.apartment.rentValue,
            initialStartDate: reservation.startDate,
            initialDuration: reservation.duration,
          ),
          arguments: reservation.apartment,
        );
      },
    );
  }
}
