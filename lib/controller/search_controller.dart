import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/model/apartment_model.dart';

import 'ApartmentController.dart';

class SearchController extends GetxController {
  final ApartmentController apartmentController = Get.find();
  final textController = TextEditingController();
  var suggestions = <Apartment>[].obs;
  Timer? _debounce;

  void onTextChanged(String text) {
    if (text.isEmpty) {
      suggestions.clear();
      return;
    }

    if (text.length < 2) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await apartmentController.searchApartments(text);
      suggestions.assignAll(apartmentController.searchResults);
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    textController.dispose();
    super.onClose();
  }
}