import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/ApartmentController.dart';
import '../controller/FilterController.dart';

class SearchSuggestionsPage extends StatelessWidget {
  final controller = Get.find<FilterController>();
  final TextEditingController searchController = TextEditingController();

  SearchSuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Apartments")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Type at least 2 letters...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                controller.searchApartments(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.searchResults.isEmpty) {
                return const Center(child: Text("No results found"));
              }
              return ListView.builder(
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final apt = controller.searchResults[index];
                  return ListTile(
                    title: Text(apt.title),
                    subtitle: Text(apt.cityName),
                    onTap: () {
                      Get.back(result: apt); // ترجع الشقة المختارة للصفحة السابقة
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
