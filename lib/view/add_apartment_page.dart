import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/add_apartment_controller.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/add_apartment_controller.dart';

class AddApartmentPage extends StatelessWidget {
  AddApartmentPage({super.key});

  final controller = Get.find<AddApartmentController>();
  final PageController pageController = PageController();

  final Color navy = const Color(0xFF274668);
  final Color softGrey = const Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Add Apartment".tr,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          _stepIndicator(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _basicInfoStep(),
                  _locationStep(),
                  _imagesStep(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========================= STEP INDICATOR =========================
  Widget _stepIndicator() {
    return Obx(
          () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
                (index) => AnimatedContainer(
              duration: 300.milliseconds,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: controller.currentStep.value == index ? 30 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: controller.currentStep.value == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========================= STEP 1 =========================
  Widget _basicInfoStep() {
    return _stepWrapper(
      Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("General Information".tr),
          _input("Apartment Title".tr, controller: controller.titleController, error: controller.titleError.value),
          _input("Description".tr, controller: controller.descriptionController, maxLines: 3, error: controller.descriptionError.value),
          Row(
            children: [
              Expanded(child: _input("Price / Month".tr, controller: controller.rentController, keyboard: TextInputType.number, error: controller.rentError.value)),
              const SizedBox(width: 12),
              Expanded(child: _input("Rooms".tr, controller: controller.roomsController, keyboard: TextInputType.number, error: controller.roomsError.value)),
            ],
          ),
          _input("Space (m²)".tr, controller: controller.spaceController, keyboard: TextInputType.number, error: controller.spaceError.value),
          const SizedBox(height: 20),
          _nextButton(() {
            if (controller.validateStep1()) {
              controller.goToStep(1, pageController);
            }
          }),
        ],
      )),
    );
  }

  // ========================= STEP 2 =========================
  // ========================= STEP 2 (المعدلة لإعادة الإحداثيات) =========================
  Widget _locationStep() {
    return _stepWrapper(
      Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Location Details".tr),
          _dropdown(
            hint: "Select Governorate".tr,
            value: controller.selectedGovernorateId.value,
            items: controller.governorates.map((g) => DropdownMenuItem(value: g.id, child: Text(g.name))).toList(),
            onChanged: (v) => v != null ? controller.onGovernorateSelected(v) : null,
            error: controller.governorateError.value,
          ),
          _dropdown(
            hint: "Select City".tr,
            value: controller.selectedCityId.value,
            items: controller.cities.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
            onChanged: (v) => v != null ? controller.onCitySelected(v) : null,
            error: controller.cityError.value,
          ),
          _input("Street Name".tr, controller: controller.streetController, error: controller.streetError.value),
          _input("Flat Number".tr, controller: controller.flatNumberController, error: controller.flatError.value),

          // 📍 إضافة الإحداثيات هنا بجانب بعضهما
          Row(
            children: [
              Expanded(
                child: _input(
                    "Longitude (opt)".tr,
                    controller: controller.longitudeController,
                    keyboard: TextInputType.number
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _input(
                    "Latitude (opt)".tr,
                    controller: controller.latitudeController,
                    keyboard: TextInputType.number
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              _backButton(() => controller.goBack(pageController)),
              const SizedBox(width: 12),
              Expanded(child: _nextButton(() {
                if (controller.validateStep2()) {
                  controller.goToStep(2, pageController);
                }
              })),
            ],
          ),
        ],
      )),
    );
  }

  // ========================= STEP 3 =========================
  Widget _imagesStep() {
    return _stepWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Apartment Gallery".tr),
           Text("Please select at least one clear image of the flat".tr, style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),
          Obx(
                () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...controller.images.map((img) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(File(img.path), width: 90, height: 90, fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () => controller.images.remove(img),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    )),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: navy.withOpacity(0.2), width: 2),
                          color: softGrey,
                        ),
                        child: Icon(Icons.add_photo_alternate_outlined, color: navy.withOpacity(0.5)),
                      ),
                    ),
                  ],
                ),
                // 💡 Validation Message for Images
                if (controller.images.isEmpty && controller.isLoading.value == false)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      controller.imageError?.value ?? "",
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _backButton(() => controller.goBack(pageController)),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                      () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      minimumSize: const Size(double.infinity, 54),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: controller.isLoading.value ? null : () {
                      if(controller.images.isEmpty) {
                        Get.snackbar("Error".tr, "Please add at least one image".tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                      } else {
                        controller.submit();
                      }
                    },
                    child: controller.isLoading.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text("Finish & Post".tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========================= UI HELPERS =========================

  Widget _stepWrapper(Widget child) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: navy),
      ),
    );
  }

  Widget _input(String hint, {required TextEditingController controller, String? error, int maxLines = 1, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: hint,
          alignLabelWithHint: true,
          errorText: error,
          filled: true,
          fillColor: softGrey,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: navy.withOpacity(0.3))),
        ),
      ),
    );
  }

  Widget _dropdown({required String hint, required int? value, required List<DropdownMenuItem<int>> items, required Function(int?) onChanged, String? error}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<int>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: hint,
          errorText: error,
          filled: true,
          fillColor: softGrey,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _nextButton(VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: onTap,
      child: Text("Continue".tr, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _backButton(VoidCallback onTap) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: navy,
        side: BorderSide(color: navy.withOpacity(0.2)),
        minimumSize: const Size(100, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: onTap,
      child:  Text("Back".tr),
    );
  }

  void _pickImages() async {
    final picker = ImagePicker();
    final imgs = await picker.pickMultiImage();
    if (imgs.isNotEmpty) {
      controller.images.addAll(imgs);
    }
  }
}