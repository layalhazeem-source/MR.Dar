import 'package:get/get.dart';

import '../core/enums/reservation_status.dart' show ReservationStatus, ReservationStatusExtension;
import '../model/reservation_model.dart';

class MyRentsController extends GetxController {
  /// جميع الحجوزات القادمة من الباك
  final RxList<ReservationModel> allReservations =
      <ReservationModel>[].obs;

  /// الحالة الحالية المختارة في الواجهة
  final Rx<ReservationStatus> currentStatus =
      ReservationStatus.pending.obs;

  /// تغيير الحالة (عند الضغط على Tab / Button)
  void changeStatus(ReservationStatus status) {
    currentStatus.value = status;
  }

  /// تحويل status النصي إلى enum
  ReservationStatus _mapStatus(String status) {
    return ReservationStatusExtension.fromString(status);
  }

  /// الحجوزات المفلترة حسب الحالة الحالية
  List<ReservationModel> get filteredReservations {
    return allReservations.where((reservation) {
      final reservationStatus = _mapStatus(reservation.status);
      return reservationStatus == currentStatus.value;
    }).toList();
  }

  /// تحميل الحجوزات (API أو Mock)
  void setReservations(List<ReservationModel> reservations) {
    allReservations.assignAll(reservations);
  }

  /// تفريغ البيانات (اختياري)
  void clearReservations() {
    allReservations.clear();
  }
}