import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../widgets/apartment_card.dart';
import 'AllApartmentsPage.dart';
import 'FilterPage.dart';
import 'apartment_details_page.dart';
import 'featured_apartments_page.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final ApartmentController controller = Get.find();

  void _openFilterPage() async {
    final result = await Get.to(() => FilterPage());

    if (result != null) {
      controller.applyFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Search Bar ----------------
            Row(
              children: [
                // Search Bar
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      hintText: "Search ",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                    ),
                    onChanged: (value) {
                      controller.searchApartments(value); // دالة البحث منفصلة
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Filter button
                GestureDetector(
                  onTap: _openFilterPage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF274668),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),

            // مؤشر الفلتر النشط
            Obx(() {
              if (controller.hasActiveFilter) {
                return Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, size: 18, color: Colors.blue[700]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Active Filters",
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${controller.filteredApartments.length} apartments found",
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.resetFilter();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          minimumSize: const Size(0, 0),
                        ),
                        child: Text(
                          "Clear All",
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            }),

            const SizedBox(height: 20),

            // قسم الشقق المميزة
            Obx(() {
              if (controller.featuredApartments.isEmpty)
                return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Featured Apartments",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),if (controller.featuredApartments.length > 5)
                        TextButton(
                          onPressed: () {
                            Get.to(
                                  () => FeaturedApartmentsPage(
                                apartments: controller.featuredApartments,
                              ),
                            );
                          },
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.featuredApartments.length,
                      itemBuilder: (context, index) {
                        final apt = controller.featuredApartments[index];
                        return Container(
                          width: 220,
                          margin: EdgeInsets.only(
                            right: 16,
                            left: index == 0 ? 0 : 0,
                          ),
                          child: ApartmentCard(
                            apartment: apt,
                            onTap: () {
                              Get.to(
                                () => ApartmentDetailsPage(apartment: apt),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),

            // قسم الشقق الأعلى تقييماً
            Obx(() {
              if (controller.topRatedApartments.isEmpty)
                return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Top Rated",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (controller.topRatedApartments.length > 3)
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.topRatedApartments.length,
                      itemBuilder: (context, index) {
                        final apt = controller.topRatedApartments[index];
                        return Container(
                          width: 220,
                          margin: EdgeInsets.only(
                            right: 16,
                            left: index == 0 ? 0 : 0,
                          ),
                          child: ApartmentCard(
                            apartment: apt,
                            onTap: () {
                              Get.to(
                                () => ApartmentDetailsPage(apartment: apt),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),

            // قسم عرض كل الشقق
            Obx(() {
              if (controller.allApartments.isEmpty) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "All Apartments",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (controller.topRatedApartments.length > 3)
                        TextButton(
                          onPressed: () {
                            Get.to(() => AllApartmentsPage());
                          },
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.allApartments.length,
                    itemBuilder: (context, index) {
                      final apt = controller.allApartments[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ApartmentCard(
                          apartment: apt,
                          onTap: () {
                            Get.to(() => ApartmentDetailsPage(apartment: apt));
                          },
                        ),
                      );
                    },
                  ),
                ],
              );
            }),

            // قسم عرض الشقق بعد التصفية
            Obx(() {
              if (controller.hasActiveFilter) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Text(
                          "Filtered Results",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${controller.filteredApartments.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // عرض الشقق المفصولة
                    if (controller.filteredApartments.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 70,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "No apartments match your search",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Try adjusting your filters",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton(
                              onPressed: _openFilterPage,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Adjust Filters",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: controller.filteredApartments.map((apt) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ApartmentCard(
                              apartment: apt,
                              onTap: () {
                                Get.to(
                                  () => ApartmentDetailsPage(apartment: apt),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                );
              }
              return const SizedBox();
            }),

            // مسافة في النهاية للـ scrolling
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
