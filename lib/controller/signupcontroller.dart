import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class signupController extends GetxController {
  Rx<XFile?> profileImage = Rx<XFile?>(null);
  Rx<XFile?> idImage = Rx<XFile?>(null);

  RxString birthDate = "".obs;
  RxString userType = "renter".obs;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  bool isConfirmHidden = true;

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
              if (image != null) profileImage.value = image;
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
              if (image != null) profileImage.value = image;
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
      if (image != null) idImage.value = image;
    } catch (e) {
      Get.snackbar("Error", "Failed to pick ID image: $e");
    }
  }

  void setUserType(String type) {
    userType.value = type;
    update(); // <<< مهم جداً
  }

  void setBirthDate(String date) {
    birthDate.value = date;
    update();
  }

  bool validateSignup() {
    if (formKey.currentState?.validate() ?? false) return true;
    return false;
  }
}
