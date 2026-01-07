import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/add_apartment_controller.dart';
import '../controller/my_account_controller.dart';


class AddApartmentPage extends StatelessWidget {
  AddApartmentPage({super.key});

  final controller = Get.find<AddApartmentController>();
  final PageController pageController = PageController();

  final account = Get.find<MyAccountController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 🔄 لسا عم يحمل البروفايل
      if (account.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // 🔒 الحساب غير مفعل
      if (!account.isAccountActive) {
        return Scaffold(
          body: Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Account Not Activated"),
              content: const Text(
                "Your account is not activated yet.\nPlease wait for admin approval.",
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        );
      }

      // ✅ الحساب مفعل → اعرض صفحة الإضافة
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.background,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Add Apartment".tr,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        body: Column(
          children: [
            _stepIndicator(context),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _basicInfoStep(context),
                    _locationStep(context),
                    _imagesStep(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ========================= STEP INDICATOR =========================
  Widget _stepIndicator(BuildContext context,) {
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
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ========================= STEP 1 =========================
  Widget _basicInfoStep(BuildContext context,) {
    return _stepWrapper(
      Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context,"General Information".tr),
          _input(context,"Apartment Title".tr, controller: controller.titleController, error: controller.titleError.value),
          _input(context,"Description".tr, controller: controller.descriptionController, maxLines: 3, error: controller.descriptionError.value),
          Row(
            children: [
              Expanded(child: _input(context,"Price / Month".tr, controller: controller.rentController, keyboard: TextInputType.number, error: controller.rentError.value)),
              const SizedBox(width: 12),
              Expanded(child: _input(context,"Rooms".tr, controller: controller.roomsController, keyboard: TextInputType.number, error: controller.roomsError.value)),
            ],
          ),
          _input(context,"Space (m²)".tr, controller: controller.spaceController, keyboard: TextInputType.number, error: controller.spaceError.value),
          const SizedBox(height: 20),
          _nextButton(context,() {
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
  Widget _locationStep(BuildContext context,) {
    return _stepWrapper(
      Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context,"Location Details".tr),
          _dropdown(
            context: context,
            hint: "Select Governorate".tr,
            value: controller.selectedGovernorateId.value,
            items: controller.governorates.map((g) => DropdownMenuItem(value: g.id, child: Text(g.name))).toList(),
            onChanged: (v) => v != null ? controller.onGovernorateSelected(v) : null,
            error: controller.governorateError.value,
          ),
          _dropdown(
            context: context,
            hint: "Select City".tr,
            value: controller.selectedCityId.value,
            items: controller.cities.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
            onChanged: (v) => v != null ? controller.onCitySelected(v) : null,
            error: controller.cityError.value,
          ),
          _input(context,"Street Name".tr, controller: controller.streetController, error: controller.streetError.value),
          _input(context,"Flat Number".tr, controller: controller.flatNumberController, error: controller.flatError.value),

          // 📍 إضافة الإحداثيات هنا بجانب بعضهما
          Row(
            children: [
              Expanded(
                child: _input(
                    context,
                    "Longitude (opt)".tr,
                    controller: controller.longitudeController,
                    keyboard: TextInputType.number
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _input(
                    context,
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
              _backButton(context,() => controller.goBack(pageController)),
              const SizedBox(width: 12),
              Expanded(child: _nextButton(context,() {
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
  Widget _imagesStep(BuildContext context,) {
    return _stepWrapper(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(context,"Apartment Gallery".tr),
           Text("Please select at least one clear image of the flat".tr, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 13)),
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
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                          color: Theme.of(context).colorScheme.background.withOpacity(0.1),
                        ),
                        child: Icon(Icons.add_photo_alternate_outlined, color: Theme.of(context).colorScheme.primary),
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
              _backButton(context,() => controller.goBack(pageController)),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                      () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 24,
      ),
      child: child,
    );
  }


  Widget _sectionTitle(BuildContext context,String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _input(BuildContext context,String hint, {required TextEditingController controller, String? error, int maxLines = 1, TextInputType keyboard = TextInputType.text}) {
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
          fillColor: Theme.of(context).colorScheme.background.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
    );
  }

  Widget _dropdown({required BuildContext context,required String hint, required int? value, required List<DropdownMenuItem<int>> items, required Function(int?) onChanged, String? error}) {
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
          fillColor: Theme.of(context).colorScheme.background.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _nextButton(BuildContext context,VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: onTap,
      child: Text("Continue".tr, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _backButton(BuildContext context,VoidCallback onTap) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
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