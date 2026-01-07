import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../controller/my_account_controller.dart';
import '../widgets/apartment_card.dart';
import 'AllApartmentsPage.dart';
import 'FilterPage.dart';
import 'apartment_details_page.dart';
import 'featured_apartments_page.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final ApartmentController controller = Get.find();
  final MyAccountController account = Get.find(); // 👈 هون

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
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      hintText: "Search".tr,
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
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
                      color: Theme.of(context).colorScheme.primary,
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
                    color:  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all( color: Theme.of(context).colorScheme.primary.withOpacity(0.3),),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, size: 18, color: Theme.of(context).colorScheme.primary,),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Active Filters".tr,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${controller.filteredApartments.length} apartments found".tr,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
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
                          "Clear All".tr,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
                       Text(
                        "Featured Apartments".tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),if (controller.featuredApartments.length > 1)
                        TextButton(
                          onPressed: () {
                            Get.to(
                                  () => FeaturedApartmentsPage(
                                apartments: controller.featuredApartments,
                              ),
                            );
                          },
                          child:  Text(
                            "See All".tr,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
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
                       Text(
                        "Top Rated".tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,

                        ),
                      ),
                      if (controller.topRatedApartments.length > 3)
                        TextButton(
                          onPressed: () {},
                          child:  Text(
                            "See All".tr,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,

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
                       Text(
                        "All Apartments".tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,

                        ),
                      ),
                      if (controller.topRatedApartments.length > 3)
                        TextButton(
                          onPressed: () {
                            Get.to(() => AllApartmentsPage());
                          },
                          child:  Text(
                            "See All".tr,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,

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
                         Text(
                          "Filtered Results".tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,

                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,

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
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                            ),
                            const SizedBox(height: 16),
                             Text(
                              "No apartments match your search".tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                             Text(
                              "Try adjusting your filters".tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                              child:  Text(
                                "Adjust Filters".tr,
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
