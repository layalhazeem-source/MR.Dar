import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';
import 'FilterPage.dart';

class AllApartmentsPage extends StatelessWidget {
  AllApartmentsPage({Key? key}) : super(key: key);

  final ApartmentController controller = Get.find();

  void _openFilterPage() async {
    final result = await Get.to(() => FilterPage());
    if (result != null) {
      controller.applyFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Apartments"),
        backgroundColor: const Color(0xFF274668),
      ),
      body: Column(
        children: [
          // ---------------- Search & Filter ----------------
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      hintText: "Search apartments...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                    ),
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                      controller.searchApartments(value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _openFilterPage,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF274668),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white, size: 28),
                  ),
                ),
              ],
            ),
          ),

          // ---------------- Apartments List ----------------
          Expanded(
            child: Obx(() {
              final apartments = controller.displayApartments;

              if (controller.isLoading.value && apartments.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (apartments.isEmpty) {
                return const Center(
                  child: Text(
                    "No apartments found",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isLoadingMore.value &&
                      controller.hasMore.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: apartments.length + 1,
                  itemBuilder: (context, index) {
                    if (index < apartments.length) {
                      final apt = apartments[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ApartmentCard(
                          apartment: apt,
                          onTap: () {
                            Get.to(() => ApartmentDetailsPage(apartment: apt));
                          },
                        ),
                      );
                    } else {
                      // Loader عند تحميل المزيد
                      return Obx(() => controller.isLoadingMore.value
                          ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : const SizedBox());
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
