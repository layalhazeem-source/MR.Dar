import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/city_model.dart';
import '../model/governorate_model.dart';
import '../service/ApartmentService.dart';

class AddApartmentController extends GetxController {
  final ApartmentService service;


  AddApartmentController({required this.service});
  // ================= Steps =================
  var currentStep = 0.obs;

  void goToStep(int step, PageController pageController) {
    currentStep.value = step;
    pageController.animateToPage(
      step,
      duration: 300.milliseconds,
      curve: Curves.ease,
    );
  }
  void goBack(PageController pageController) {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: 300.milliseconds,
        curve: Curves.ease,
      );
    }
  }

  // ================= Validation Errors =================
  var titleError = RxnString();
  var descriptionError = RxnString();
  var rentError = RxnString();
  var roomsError = RxnString();
  var spaceError = RxnString();

  var governorateError = RxnString();
  var cityError = RxnString();
  var streetError = RxnString();
  var flatError = RxnString();

  //--------
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final rentController = TextEditingController();
  final roomsController = TextEditingController();
  final spaceController = TextEditingController();
  final streetController = TextEditingController();
  final flatNumberController = TextEditingController();

  final longitudeController = TextEditingController();
  final latitudeController = TextEditingController();



  // location
  var governorates = <GovernorateModel>[].obs;
  var cities = <CityModel>[].obs;
  var selectedGovernorateId = RxnInt();
  var selectedCityId = RxnInt();

  // images
  var images = <XFile>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadGovernorates();
  }
  bool validateStep1() {
    titleError.value = titleController.text.isEmpty ? "Title is required" : null;
    descriptionError.value =
    descriptionController.text.isEmpty ? "Description is required" : null;
    rentError.value = rentController.text.isEmpty ? "Price is required" : null;
    roomsError.value = roomsController.text.isEmpty ? "Rooms is required" : null;
    spaceError.value = spaceController.text.isEmpty ? "Space is required" : null;

    return titleError.value == null &&
        descriptionError.value == null &&
        rentError.value == null &&
        roomsError.value == null &&
        spaceError.value == null;
  }

  bool validateStep2() {
    governorateError.value =
    selectedGovernorateId.value == null ? "Governorate is required" : null;
    cityError.value =
    selectedCityId.value == null ? "City is required" : null;
    streetError.value =
    streetController.text.isEmpty ? "Street is required" : null;
    flatError.value =
    flatNumberController.text.isEmpty ? "Flat number is required" : null;

    return governorateError.value == null &&
        cityError.value == null &&
        streetError.value == null &&
        flatError.value == null;
  }

  Future<void> loadGovernorates() async {
    governorates.value = await service.getGovernorates();
  }

  void onGovernorateSelected(int id) {
    selectedGovernorateId.value = id;
    cities.value =
        governorates.firstWhere((g) => g.id == id).cities;
    selectedCityId.value = null;
  }
  void onCitySelected(int id) {
    selectedCityId.value = id;
  }



  Future<void> submit() async {
try {
  isLoading.value = true;


  await service.createApartment(
    title: titleController.text.trim(),
    description: descriptionController.text.trim(),
    rentValue: double.parse(rentController.text),
    rooms: int.parse(roomsController.text),
    space: double.parse(spaceController.text),
    notes: "",
    governorateId: selectedGovernorateId.value!,
    cityId: selectedCityId.value!,
    street: streetController.text.trim(),
    flatNumber: flatNumberController.text.trim(),
    longitude: longitudeController.text.isEmpty
        ? null
        : int.parse(longitudeController.text),
    latitude: latitudeController.text.isEmpty
        ? null
        : int.parse(latitudeController.text),
    houseImages: images,
  );

  isLoading.value = false;

  Get.offAllNamed('/home');

  Get.snackbar(
    "Apartment added ",
    "Your apartment was added successfully\nWaiting for admin approval",
    backgroundColor: const Color(0xFF0F2A44),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    borderRadius: 16,
    duration: const Duration(seconds: 3),
  );
} catch (e) {
    Get.snackbar(
    "Error",
    e.toString(),
    backgroundColor: Colors.red,
    colorText: Colors.white,
    );
    } finally {
    // 🔴 هذا أهم سطر
    isLoading.value = false;
  }}
  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    rentController.dispose();
    roomsController.dispose();
    spaceController.dispose();
    streetController.dispose();
    flatNumberController.dispose();
    super.onClose();
  }

}
