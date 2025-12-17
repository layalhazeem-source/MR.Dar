import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';

class SignupController extends GetxController {
  bool isLoading = false;

  final AuthService api;
  SignupController({required this.api});

  Rx<XFile?> profileImage = Rx<XFile?>(null);
  Rx<XFile?> idImage = Rx<XFile?>(null);
  RxString birthDate = "".obs;
  RxInt role = 0.obs;
  RxString profileImageError = RxString("");
  RxString idImageError = RxString("");
  String roleError = "";
  String phoneError = "";

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

  void setRole(int type) {
    role.value = type;
    roleError = "";
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

    if (profileImage.value == null) {
      profileImageError.value = "Profile image is required!";
      isValid = false;
    } else {
      profileImageError.value = "";
    }

    if (idImage.value == null) {
      idImageError.value = "ID image is required!";
      isValid = false;
    } else {
      idImageError.value = "";
    }

    if (birthDate.value.isEmpty) {
      birthDateController.text = "";
      isValid = false;
    }

    if (role.value == 0) {
      roleError = "Please select a role (Renter or Owner)";
      isValid = false;
    } else {
      roleError = "";
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      isValid = false;
    }

    return isValid;
  }

  @override
  void onInit() {
    super.onInit();

    phoneController.addListener(() {
      if (phoneError.isNotEmpty) {
        phoneError = "";
        update();
      }
    });
  }

  Future<void> signupUser() async {
    if (!validateAllFields()) {
      update();
      return;
    }

    isLoading = true;
    update();

    try {
      final response = await api.signup(
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

      final prefs = await SharedPreferences.getInstance();

      isLoading = false;
      update();

      Get.snackbar(
        'Success',
        'Account created successfully!',
        colorText: Colors.white,
      );

      Get.offAll(() => Home());
    } on ServerException catch (e) {
      isLoading = false;
      update();

      if (e.errModel.errors != null && e.errModel.errors!['phone'] != null) {
        phoneError = e.errModel.errors!['phone'][0].toString();
        update();

        Get.snackbar(
          "Account exists",
          phoneError,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.defaultDialog(
          title: "Account already exists",
          middleText:
          "This phone number is already registered.\nDo you want to log in instead?",
          textCancel: "Cancel",
          textConfirm: "Go to Login",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
            Get.offAllNamed('/login'); // أو Get.to(() => Login())
          },
        );

      }

      print(" ServerException message: ${e.errModel.errorMessage}");
      print(" ServerException errors: ${e.errModel.errors}");
    } catch (e) {
      isLoading = false;
      update();
      Get.snackbar(
        'Unexpected Error',
        'Something went wrong: $e',
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
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
