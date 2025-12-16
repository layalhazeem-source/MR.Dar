import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/apartment_model.dart';
import '../service/ApartmentService.dart';

class ApartmentController extends GetxController {
  final ApartmentService service;

  ApartmentController({required this.service});

  // البيانات
  RxList<Apartment> allApartments = <Apartment>[].obs;
  RxList<Apartment> featuredApartments = <Apartment>[].obs;
  RxList<Apartment> topRatedApartments = <Apartment>[].obs;

  // حالات الواجهة
  RxBool isLoading = false.obs;
  RxBool isCreating = false.obs; // حالة إنشاء شقة جديدة
  RxString errorMessage = ''.obs;
  RxString createMessage = ''.obs; // رسالة نتيجة الإنشاء

  // ========================= تحميل كل الشقق =========================
  Future<void> loadApartments() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      allApartments.assignAll(
        await service.getAllApartments(),
      );

      featuredApartments.assignAll(
        await service.getApartmentsByQuery(maxPrice: 200),
      );

      topRatedApartments.assignAll(
        await service.getApartmentsByQuery(orderBy: 'rate'),
      );

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
//------------

  // ========================= إنشاء شقة جديدة =========================
  Future<bool> createApartment({
    required String title,
    required String description,
    required double rentValue,
    required int rooms,
    required double space,
    required String notes,
    required int governorateId,
    required int? cityId,
    required String street,
    required int flatNumber,
    required int? longitude,
    required int? latitude,
    required List<XFile> houseImages,
  }) async {
    try {
      isCreating.value = true;
      createMessage.value = "";

      final response = await service.createApartment(
        title: title,
        description: description,
        rentValue: rentValue,
        rooms: rooms,
        space: space,
        notes: notes,
        governorateId: governorateId,
        cityId: cityId,
        street: street,
        flatNumber: flatNumber,
        longitude: longitude,
        latitude: latitude,
        houseImages: houseImages,
      );

      // تحديث القائمة بعد الإضافة الناجحة
      await loadApartments();

      createMessage.value = "تم إنشاء الشقة بنجاح!";
      return true;

    } catch (e) {
      createMessage.value = "خطأ في إنشاء الشقة: $e";
      return false;
    } finally {
      isCreating.value = false;
    }
  }


  @override
  void onInit() {
    loadApartments();
    super.onInit();
  }
}
