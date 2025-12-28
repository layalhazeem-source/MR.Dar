import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../controller/UserController.dart';
import '../model/apartment_model.dart';
import 'booking_date_page.dart';

class ApartmentDetailsPage extends StatelessWidget {
  final Apartment apartment;
  final user = Get.find<UserController>();

  ApartmentDetailsPage({super.key, required this.apartment});

  final apartmentController = Get.find<ApartmentController>();
  final PageController _pageController = PageController();
  final RxInt currentImageIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // ===== AppBar =====
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),

      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Images Slider =====
                SizedBox(
                  height: 320,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: apartment.houseImages.length,
                        onPageChanged: (index) {
                          currentImageIndex.value = index;
                        },
                        itemBuilder: (_, index) {
                          return Image.network(
                            apartment.houseImages[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),

                      // ===== Left Arrow =====
                      Obx(() => currentImageIndex.value > 0
                          ? Positioned(
                        left: 12,
                        top: 140,
                        child: _circleIcon(
                          Icons.arrow_back_ios,
                              () {
                            _pageController.previousPage(
                              duration:
                              const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      )
                          : const SizedBox()),

                      // ===== Right Arrow =====
                      Obx(() => currentImageIndex.value <
                          apartment.houseImages.length - 1
                          ? Positioned(
                        right: 12,
                        top: 140,
                        child: _circleIcon(
                          Icons.arrow_forward_ios,
                              () {
                            _pageController.nextPage(
                              duration:
                              const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      )
                          : const SizedBox()),

                      // ===== Dots =====
                      Positioned(
                        bottom: 14,
                        left: 0,
                        right: 0,
                        child: Obx(
                              () => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                apartment.houseImages.length,
                                    (index) => AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  width: currentImageIndex.value == index
                                      ? 10
                                      : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color:
                                    currentImageIndex.value == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== Content Card =====
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                apartment.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                              Obx(() {
                                final isFav =
                                apartmentController.favoriteIds.contains(apartment.id);
                                return IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.black,
                                  ),
                                  onPressed: () =>
                                      apartmentController.toggleFavorite(apartment.id),
                                );
                              }),

                            // Text(
                            //   "\$${apartment.rentValue}",
                            //   style: const TextStyle(
                            //     fontSize: 26,
                            //     fontWeight: FontWeight.bold,
                            //     color: Color(0xFF274668),
                            //   ),
                            // ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 18,
                                color: Color(0xFF274668)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "${apartment.street}, ${apartment.cityName}, ${apartment.governorateName}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Amenities

                        const Text(
                          "Specifications",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.0,
                          children: [
                            _specItem(
                              Icons.bed,
                              "Rooms",
                              "${apartment.rooms}",
                            ),
                            _specItem(
                              Icons.square_foot,
                              "Space",
                              "${apartment.space} m²",
                            ),
                            _specItem(
                              Icons.wifi,
                              "Wi-Fi",
                              "Available",
                            ),
                            _specItem(
                              Icons.apartment,
                              "Type",
                              "Apartment",
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Description
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          apartment.description.isNotEmpty
                              ? apartment.description
                              : "A beautiful apartment with modern amenities and comfortable living space.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),

                        if (apartment.flatNumber.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Text(
                            "Flat Number",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            apartment.flatNumber,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== Book Button =====
          if (!user.isOwner)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 💰 Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "\$${apartment.rentValue}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF274668),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // 📌 Book button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF274668),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Get.to(
                                () => BookingDatePage(
                              houseId: apartment.id,
                              rentValue: apartment.rentValue,
                            ),
                            arguments: apartment,
                          );
                        },
                        child: const Text(
                          "Book Now",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }

  // ===== Helpers =====
  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _specItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF274668),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }




}
