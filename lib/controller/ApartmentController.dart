import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/apartment_model.dart';
import '../service/ApartmentService.dart';

class ApartmentController extends GetxController {
  final ApartmentService service;

  ApartmentController({required this.service});

  // data
  RxList<Apartment> allApartments = <Apartment>[].obs;
  RxList<Apartment> featuredApartments = <Apartment>[].obs;
  RxList<Apartment> topRatedApartments = <Apartment>[].obs;


  RxBool isLoading = false.obs;
  RxBool isCreating = false.obs;
  RxString errorMessage = ''.obs;
  RxString createMessage = ''.obs;

//load apartments
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

  //createApartment
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

      // refresh
      await loadApartments();

      createMessage.value = "apartment added successfully";
      return true;

    } catch (e) {
      createMessage.value = "failed to add apartment: $e";
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
