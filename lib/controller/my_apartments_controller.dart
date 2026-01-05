import 'package:get/get.dart';

import '../model/apartment_model.dart';
import '../core/enums/apartment_status.dart';
import '../service/ApartmentService.dart';

class MyApartmentsController extends GetxController {
  final ApartmentService apartmentService;

  MyApartmentsController({required this.apartmentService});

  /// جميع الشقق
  final RxList<Apartment> allApartments = <Apartment>[].obs;

  /// الحالة الحالية المختارة
  final Rx<ApartmentStatus> currentStatus = ApartmentStatus.pending.obs;

  /// حالات الواجهة
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyApartments();
  }

  //تغيير الحالة المختارة
  void changeStatus(ApartmentStatus status) {
    currentStatus.value = status;
  }

  /// جلب شقق المالك من السيرفر
  Future<void> fetchMyApartments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final apartments = await apartmentService.getMyApartments();
      allApartments.assignAll(apartments);
      update();
      // طباعة البيانات للتشخيص
      print('Total apartments fetched: ${allApartments.length}');
      for (var apt in allApartments) {
        print('Apartment ${apt.id}: status = ${apt.apartmentStatus}');
      }
    } catch (e) {
      errorMessage.value = 'load apartments failed';
    } finally {
      isLoading.value = false;
    }
  }

  /// فلترة الشقق حسب الحالة
  List<Apartment> get filteredApartments {
    return allApartments.where((apartment) {
      final status = ApartmentStatusExtension.fromDynamic(
        apartment.apartmentStatus,
      );
      return status == currentStatus.value;
    }).toList();
  }

  /// تعداد الشقق حسب الحالة
  int getApartmentCountByStatus(ApartmentStatus status) {
    return allApartments.where((apartment) {
      final aptStatus = ApartmentStatusExtension.fromDynamic(
        apartment.apartmentStatus,
      );
      return aptStatus == status;
    }).length;
  }

  /// تحديث قائمة الشقق
  void updateApartments(List<Apartment> apartments) {
    allApartments.assignAll(apartments);
  }

  /// مسح قائمة الشقق
  void clearApartments() {
    allApartments.clear();
  }

  /// البحث عن شقة بواسطة الـ ID
  Apartment? getApartmentById(int id) {
    return allApartments.firstWhereOrNull((apt) => apt.id == id);
  }

  /// تحديث حالة شقة معينة
  void updateApartmentStatus(int apartmentId, ApartmentStatus newStatus) {
    final index = allApartments.indexWhere((apt) => apt.id == apartmentId);
    if (index != -1) {
      // Note: Since Apartment is immutable, we need to create a new instance
      final oldApartment = allApartments[index];
      final updatedApartment = Apartment(
        id: oldApartment.id,
        title: oldApartment.title,
        description: oldApartment.description,
        rentValue: oldApartment.rentValue,
        rooms: oldApartment.rooms,
        space: oldApartment.space,
        notes: oldApartment.notes,
        cityId: oldApartment.cityId,
        cityName: oldApartment.cityName,
        governorateId: oldApartment.governorateId,
        governorateName: oldApartment.governorateName,
        street: oldApartment.street,
        flatNumber: oldApartment.flatNumber,
        longitude: oldApartment.longitude,
        latitude: oldApartment.latitude,
        houseImages: oldApartment.houseImages,
        apartmentStatus: newStatus.toString().split('.').last,
      );
      allApartments[index] = updatedApartment;
      allApartments.refresh();
      update();
    }
  }

  /// 🔄 إعادة تحميل البيانات (عند تغيير اللغة)
  Future<void> reload() async {
    await fetchMyApartments();
  }
}
