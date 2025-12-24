import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../service/userService.dart';
import '../controller/my_account_controller.dart';

class EditProfileController extends GetxController {
  final UserService userService;
  final MyAccountController myAccountController;

  EditProfileController({
    required this.userService,
    required this.myAccountController,
  });

  final isUpdating = false.obs;
  final hasAnyChanges = false.obs;
  final errorMessage = ''.obs;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final confirmDialogPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final selectedImage = Rx<XFile?>(null);
  final picker = ImagePicker();

  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = myAccountController.user.value;
    firstNameController = TextEditingController(text: user?.firstName ?? "");
    lastNameController = TextEditingController(text: user?.lastName ?? "");
    phoneController = TextEditingController(text: user?.phone ?? "");

    void listener() => checkChanges();
    firstNameController.addListener(listener);
    lastNameController.addListener(listener);
    phoneController.addListener(listener);
    newPasswordController.addListener(listener);
    confirmPasswordController.addListener(listener);
  }

  void checkChanges() {
    final user = myAccountController.user.value;
    if (user == null) return;

    bool changed =
        firstNameController.text.trim() != user.firstName ||
        lastNameController.text.trim() != user.lastName ||
        phoneController.text.trim() != user.phone ||
        selectedImage.value != null ||
        newPasswordController.text.isNotEmpty;

    hasAnyChanges.value = changed;
  }

  Future<void> selectProfileImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      selectedImage.value = image;
      checkChanges();
    }
  }

  // ... (نفس التعريفات السابقة)

  Future<bool> saveAllChanges(String confirmPassword) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';

      final formData = FormData();
      formData.fields.addAll([
        MapEntry('first_name', firstNameController.text.trim()),
        MapEntry('last_name', lastNameController.text.trim()),
        MapEntry('phone', phoneController.text.trim()),
        MapEntry('current_password', confirmPassword),
      ]);

      if (newPasswordController.text.isNotEmpty) {
        formData.fields.add(
          MapEntry('new_password', newPasswordController.text.trim()),
        );
        formData.fields.add(
          MapEntry(
            'new_password_confirmation',
            confirmPasswordController.text.trim(),
          ),
        );
      }

      if (selectedImage.value != null) {
        formData.files.add(
          MapEntry(
            'profile_image',
            await MultipartFile.fromFile(
              selectedImage.value!.path,
              filename: 'profile.jpg',
            ),
          ),
        );
      }

      final response = await userService.updateProfile(formData);

      // التأكد من نجاح العملية من خلال الستاتوس كود أو الحقل status
      if (response['status'] == 'success') {
        await myAccountController.loadProfile();
        _clearSensitiveData();
        return true;
      } else {
        // إذا أرجع السيرفر خطأ (مثل كلمة سر خاطئة)
        errorMessage.value =
            response['message'] ?? 'Incorrect current password';
        return false;
      }
    } catch (e) {
      // التعامل مع أخطاء الشبكة أو أخطاء Dio
      if (e is DioException) {
        errorMessage.value =
            e.response?.data['message'] ?? 'Validation Error: Check your data';
      } else {
        errorMessage.value = 'Connection failed. Please try again.';
      }
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  void _clearSensitiveData() {
    selectedImage.value = null;
    newPasswordController.clear();
    confirmPasswordController.clear();
    confirmDialogPasswordController.clear();
    hasAnyChanges.value = false;
  }
}
