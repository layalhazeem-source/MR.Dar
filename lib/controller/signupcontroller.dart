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

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  bool isPasswordHidden = true;
  bool isConfirmHidden = true;

  @override
  void onInit() {
    super.onInit();
  }

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
    if (!(formKey.currentState?.validate() ?? false)) {
      Get.snackbar('Error', 'Please fill all required fields correctly');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }
    if (birthDate.value.isEmpty) {
      Get.snackbar('Error', 'Please select date of birth');
      return;
    }
    if (role.value == 0) {
      Get.snackbar('Error', 'Please select a role (Renter or Owner)');
      return;
    }
    isLoading = true;
    update();

    try {
      final response =  await api.signup(
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
    // بعد التسجيل، احصل على التوكن من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
    print("Token saved successfully: $token");
    } else {
    print("Warning: Token not found after signup!");
    }
      isLoading = false;
      update();

      Get.snackbar(
        'Success ',
        'Account created successfully!',
        colorText: Colors.white,
      );

      Get.offAll(() => Home());
    } on ServerException catch (e) {
      isLoading = false;
      update();

      Get.snackbar(
        'Error ',
        e.errModel.errorMessage,

        colorText: Colors.white,
      );
      print("Server Exception: ${e.errModel.errorMessage}");
    } catch (e) {
      isLoading = false;
      update();
      Get.snackbar(
        'Unexpected Error ',
        'Something went wrong: $e',
        colorText: Colors.white,
      );
    }
  }
  }
