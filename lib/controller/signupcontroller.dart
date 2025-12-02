import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';

class signupController extends GetxController {
  Rx<XFile?> profileImage = Rx<XFile?>(null);
  Rx<XFile?> idImage = Rx<XFile?>(null);

  RxString birthDate = "".obs;
  RxInt role = 2.obs;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var birthDateController = TextEditingController();

  bool isConfirmHidden = true;
  late final AuthService authService;

  @override
  void onInit() {
    authService = AuthService();
    super.onInit();
  }

  void toggleConfirmPassword() {
    isConfirmHidden = !isConfirmHidden;
    update();
  }

  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  // اختيار صورة Profile من Camera أو Gallery
  void selectProfileImage() {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () async {
              Get.back();
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                profileImage.value = image;
                update();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () async {
              Get.back();
              final XFile? image = await picker.pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                profileImage.value = image;
                update();
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // اختيار صورة ID
  void pickIdImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        idImage.value = image;
        update();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick ID image: $e");
    }
  }

  void setRole(int type) {
    role.value = type;
    update();
  }

  void setBirthDate(String date) {
    birthDate.value = date;
    birthDateController.text = date; // نحدث الكونترولر للنص
    update();
  }

  Future<void> signupUser() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        await authService.signup(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phone: phoneController.text.trim(),
          password: passwordController.text.trim(),
          confirmPassword: confirmPasswordController.text.trim(), // ← هنا

          birthDate: birthDate.value,
          role: role.value,

          //  ⬅⬅⬅  هدول السطرين يلي كنتي عم تسألي وين ينحطوا
          profileImage: profileImage.value != null
              ? File(profileImage.value!.path)
              : null,

          idImage: idImage.value != null ? File(idImage.value!.path) : null,
        );

        Get.snackbar('Success', 'Account created successfully!');
        Get.off(() => Home());
      } on SereverException catch (e) {
        Get.snackbar('Error', e.errModel.errorMessage);
      }
    }
  }
}
