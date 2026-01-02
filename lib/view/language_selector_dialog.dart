import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/locale/locale_controller.dart';

void showLanguageSelector() {
  final LocaleController controller = Get.find<LocaleController>();

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Change app language".tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          ListTile(
            leading: const Text("🇸🇾", style: TextStyle(fontSize: 22)),
            title: const Text("العربية"),
            onTap: () {
              controller.changeLocale('ar');
              Get.back();
            },
          ),

          ListTile(
            leading: const Text("🇬🇧", style: TextStyle(fontSize: 22)),
            title: const Text("English"),
            onTap: () {
              controller.changeLocale('en');
              Get.back();
            },
          ),
        ],
      ),
    ),
  );
}
