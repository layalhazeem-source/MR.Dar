import 'package:get/get.dart';

import '../model/apartment_model.dart';
import '../core/enums/apartment_status.dart';

class MyApartmentsController extends GetxController {
  /// جميع الشقق
  final RxList<Apartment> allApartments = <Apartment>[].obs;

  /// الحالة الحالية المختارة
  final Rx<ApartmentStatus> currentStatus =
      ApartmentStatus.pending.obs;

  void changeStatus(ApartmentStatus status) {
    currentStatus.value = status;
  }

  /// فلترة الشقق حسب الحالة
  List<Apartment> get filteredApartments {
    return allApartments.where((apartment) {
      final apartmentStatus =
      ApartmentStatusExtension.fromString(apartment.apartmentStatus);
      return apartmentStatus == currentStatus.value;
    }).toList();
  }

  void setApartments(List<Apartment> apartments) {
    allApartments.assignAll(apartments);
  }

  void clearApartments() {
    allApartments.clear();
  }
}
