import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/errors/exceptions.dart';
import '../service/auth_service.dart';
import '../view/home.dart';
import 'UserController.dart';

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
    role.value = type; // 'owner' أو 'renter'
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

    if (role.value.isEmpty) {
      Get.snackbar('Error', 'Please select a role');
      isValid = false;
    }


    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
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
      final response = await api.signup(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
        birthDate: birthDate.value,
        role:role.value,
        profileImage: profileImage.value != null
            ? File(profileImage.value!.path)
            : null,
        idImage: idImage.value != null ? File(idImage.value!.path) : null,
      );

      final prefs = await SharedPreferences.getInstance();

      print("   id: ${prefs.getString("id")}");
      print("   first_name: ${prefs.getString("first_name")}");
      print("   last_name: ${prefs.getString("last_name")}");
      print("   phone: ${prefs.getString("phone")}");
      print("   role: ${prefs.getString("role")}");
      print("   date_of_birth: ${prefs.getString("date_of_birth")}");
      print("   token: ${prefs.getString("token")?.substring(0, 20)}...");

      isLoading = false;
      update();

      Get.snackbar(
        'Success',
        'Account created successfully!',
        colorText: Colors.white,
      );
      final userCtrl = Get.put(UserController());
      await userCtrl.loadUserRole();
      Get.offAll(() => Home());

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