import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  // form fields
  var title = ''.obs;
  var description = ''.obs;
  var rentValue = ''.obs;
  var rooms = ''.obs;
  var space = ''.obs;
  var street = ''.obs;
  var flatNumber = ''.obs;

  // location
  var governorates = <GovernorateModel>[].obs;
  var cities = [].obs;
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

  Future<void> loadGovernorates() async {
    governorates.value = await service.getGovernorates();
  }

  void onGovernorateSelected(int id) {
    selectedGovernorateId.value = id;
    cities.value =
        governorates.firstWhere((g) => g.id == id).cities;
    selectedCityId.value = null;
  }

  bool validate() {
    if (title.isEmpty ||
        rentValue.isEmpty ||
        rooms.isEmpty ||
        space.isEmpty ||
        street.isEmpty ||
        flatNumber.isEmpty ||
        selectedCityId.value == null ||
        images.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return false;
    }
    return true;
  }

  Future<void> submit() async {
    if (!validate()) return;

    isLoading.value = true;

    await service.createApartment(
      title: title.value,
      description: description.value,
      rentValue: double.parse(rentValue.value),
      rooms: int.parse(rooms.value),
      space: double.parse(space.value),
      notes: "", // ❌ ما عم نستخدمها
      governorateId: selectedGovernorateId.value!,
      cityId: selectedCityId.value!,
      street: street.value,
      flatNumber: int.parse(flatNumber.value),
      longitude: null,
      latitude: null,
      houseImages: images,
    );

    isLoading.value = false;

    Get.offAllNamed('/home');

    Get.snackbar(
      "Apartment added 🏠",
      "Your apartment was added successfully\nWaiting for admin approval",
      backgroundColor: const Color(0xFF0F2A44),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
    );

  }
}
