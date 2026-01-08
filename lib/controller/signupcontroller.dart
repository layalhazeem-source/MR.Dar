import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';
import 'UserController.dart';
import 'homecontroller.dart';
import 'my_account_controller.dart';

class SignupController extends GetxController {
  bool isLoading = false;

  final AuthService api;
  SignupController({required this.api});

  Rx<XFile?> profileImage = Rx<XFile?>(null);
  Rx<XFile?> idImage = Rx<XFile?>(null);
  RxString birthDate = "".obs;
  RxString role = ''.obs; // owner | renter
  RxString profileImageError = RxString("");
  RxString idImageError = RxString("");

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmHidden = true;

  void toggleConfirmPassword() {
    isConfirmHidden = !isConfirmHidden;
    update();
  }

  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  void togglePassword() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

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
                imageQuality: 80,
              );
              if (image != null) {
                profileImage.value = image;
                profileImageError.value = "";

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
                imageQuality: 80,
              );
              if (image != null) {
                profileImage.value = image;
                profileImageError.value = "";

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

  void pickIdImage() async {
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
                imageQuality: 80,
              );
              if (image != null) {
                idImage.value = image;
                idImageError.value = "";
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
                imageQuality: 80,
              );
              if (image != null) {
                idImage.value = image;
                idImageError.value = "";
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

  void setRole(String type) {
    role.value = type; // owner | renter

    Get.closeAllSnackbars();

    update();
  }

  void setBirthDate(String date) {
    birthDate.value = date;
    birthDateController.text = date;
    update();
  }


  bool validateAllFields() {
    bool isValid = true;

    if (!(formKey.currentState?.validate() ?? false)) {
      isValid = false;
    }

    profileImageError.value =
    profileImage.value == null ? "Profile image is required!" : "";

    idImageError.value =
    idImage.value == null ? "ID image is required!" : "";

    if (birthDate.value.isEmpty) {
      isValid = false;
    }

    if (role.value.isEmpty) {
      Get.snackbar('Error', 'Please select a role');
      isValid = false;
    }

    return isValid;
  }

  Future<void> signupUser() async {
    if (!validateAllFields()) {
      update();
      return;
    }

    isLoading = true;
    update();

    try {
      await api.signup(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        birthDate: birthDate.value,
        role: role.value,
        profileImage: profileImage.value != null
            ? File(profileImage.value!.path)
            : null,
        idImage: idImage.value != null ? File(idImage.value!.path) : null,
      );

      isLoading = false;
      update();

      Get.snackbar(
        'Success',
        'Account created successfully!',
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
      final userCtrl = Get.put(UserController());
      await userCtrl.loadUserRole();
      await Future.delayed(Duration(milliseconds: 300));

      // load profile immediately
      try {
        await Get.find<MyAccountController>().loadProfile();
      } catch (e) {
        print("Could not load profile immediately: $e");
      }

      Get.offAll(
        () => Home(),
        binding: BindingsBuilder(() {
          Get.put(HomeController());
        }),
      );
    } on ServerException catch (e) {
      isLoading = false;
      update();

      Get.snackbar(
        'Error',
        e.errModel.errorMessage,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      print("Server Exception: ${e.errModel.errorMessage}");
    } catch (e) {
      isLoading = false;
      update();
      Get.snackbar(
        'Unexpected Error',
        'Something went wrong: $e',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    birthDateController.dispose();
    super.onClose();
  }
}
