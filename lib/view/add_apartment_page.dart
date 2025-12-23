import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/add_apartment_controller.dart';

class AddApartmentPage extends StatelessWidget {
  AddApartmentPage({super.key});

  final controller = Get.find<AddApartmentController>();
  final PageController pageController = PageController();

  final Color navy = const Color(0xFF0F2A44);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Add Apartment",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _stepIndicator(),
          Expanded(
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
        ],
      ),

    );
  }

  // ========================= STEP INDICATOR =========================
  Widget _stepIndicator() {
    return Obx(
          () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
                (index) => AnimatedContainer(
              duration: 250.milliseconds,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: controller.currentStep.value == index ? 40 : 25,
              height: 6,
              decoration: BoxDecoration(
                color: controller.currentStep.value == index
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
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
    return _card(
      Column(

        children: [
          _input("Title", onChanged: (v) => controller.title.value = v),
          _input("Description",
              maxLines: 3,
              onChanged: (v) => controller.description.value = v),
          _input("Price / Night",
              keyboard: TextInputType.number,
              onChanged: (v) => controller.rentValue.value = v),
          _input("Rooms",
              keyboard: TextInputType.number,
              onChanged: (v) => controller.rooms.value = v),
          _input("Space (m²)",
              keyboard: TextInputType.number,
              onChanged: (v) => controller.space.value = v),

      _nextButton(() {
        controller.goToStep(1, pageController);
      }),

      ],
      ),
    );
  }

  // ========================= STEP 2 =========================
  Widget _locationStep() {
    return _card(
      Column(
        children: [
          Obx(
                () => _dropdown(
              hint: "Governorate",
              value: controller.selectedGovernorateId.value,
              items: controller.governorates
                  .map((g) => DropdownMenuItem(
                value: g.id,
                child: Text(g.name),
              ))
                  .toList(),
              onChanged: (v) => controller.onGovernorateSelected(v!),
            ),
          ),
          Obx(
                () => _dropdown(
              hint: "City",
              value: controller.selectedCityId.value,
              items: controller.cities
                  .map<DropdownMenuItem<int>>(
                    (c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name),
                ),
              )
                  .toList(),
              onChanged: (v) => controller.selectedCityId.value = v,
            ),
          ),
          _input("Street", onChanged: (v) => controller.street.value = v),
          _input("Flat Number",
              onChanged: (v) => controller.flatNumber.value = v),
    _nextButton(() {
    controller.goToStep(2, pageController);
    }),

    ],
      ),
    );
  }

  // ========================= STEP 3 =========================
  Widget _imagesStep() {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Apartment Images",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Obx(
                () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...controller.images.map(
                      (img) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(img.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Obx(
                () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed:
              controller.isLoading.value ? null : controller.submit,
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Add Apartment"),
            ),
          )
        ],
      ),
    );
  }

  // ========================= HELPERS =========================
  Widget _card(Widget child) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(child: child),
    );
  }

  Widget _input(String hint,
      {int maxLines = 1,
        TextInputType keyboard = TextInputType.text,
        required Function(String) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        maxLines: maxLines,
        keyboardType: keyboard,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required int? value,
    required List<DropdownMenuItem<int>> items,
    required Function(int?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _nextButton(VoidCallback onTap) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onTap,
        child: const Text("Next →"),
      ),
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
