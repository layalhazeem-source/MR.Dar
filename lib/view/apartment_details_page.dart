import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../controller/UserController.dart';
import '../model/apartment_model.dart';
import 'booking_date_page.dart';

class ApartmentDetailsPage extends StatelessWidget {
  final Apartment apartment;
  ApartmentDetailsPage({super.key, required this.apartment});

  final user = Get.find<UserController>();
  final apartmentController = Get.find<ApartmentController>();
  final PageController _pageController = PageController();
  final RxInt currentImageIndex = 0.obs;

  static const kPrimary = Color(0xFF274668);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [

            // ================= IMAGE SLIDER =================
            SizedBox(
              height: 360,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: apartment.houseImages.length,
                    onPageChanged: (i) => currentImageIndex.value = i,
                    itemBuilder: (_, index) {
                      return Image.network(
                        apartment.houseImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: _glassCircle(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Get.back(),
                      ),
                    ),
                  ),

                  Obx(() => currentImageIndex.value > 0
                      ? Positioned(
                    left: 12,
                    top: 170,
                    child: _glassCircle(
                      icon: Icons.arrow_back_ios,
                      onTap: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  )
                      : const SizedBox()),

                  Obx(() => currentImageIndex.value <
                      apartment.houseImages.length - 1
                      ? Positioned(
                    right: 12,
                    top: 170,
                    child: _glassCircle(
                      icon: Icons.arrow_forward_ios,
                      onTap: () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  )
                      : const SizedBox()),

                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Obx(
                          () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          apartment.houseImages.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin:
                            const EdgeInsets.symmetric(horizontal: 4),
                            width:
                            currentImageIndex.value == index ? 18 : 8,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= CONTENT =================
            Container(
              transform: Matrix4.translationValues(0, -24, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ===== TITLE =====
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          apartment.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Obx(() {
                        final isFav = apartmentController.favoriteIds
                            .contains(apartment.id);
                        return IconButton(
                          icon: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => apartmentController
                              .toggleFavorite(apartment.id),
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: kPrimary),
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

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 2.6,
                    children: [
                      _specItem(Icons.bed, "Rooms".tr,
                          "${apartment.rooms}"),
                      _specItem(Icons.square_foot, "Space".tr,
                          "${apartment.space} m²".tr),
                      _specItem(Icons.wifi, "Wi-Fi".tr, "Available".tr),
                      _specItem(Icons.apartment, "Type".tr, "Apartment".tr),
                    ],
                  ),

                  const SizedBox(height: 28),

                   Text(
                    "About This House".tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    apartment.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 24),

                   Text(
                    "Flat Number".tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    apartment.flatNumber,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),

                  // ================= PRICE + BUTTON =================
                  if (!user.isOwner)
                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Price".tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "\$${apartment.rentValue}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: kPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimary,
                                padding:
                                const EdgeInsets.symmetric(
                                    vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () {
                                Get.to(
                                      () => BookingDatePage(
                                    houseId: apartment.id,
                                    rentValue:
                                    apartment.rentValue,
                                  ),
                                  arguments: apartment,
                                );
                              },
                              child:  Text(
                                "Reserve".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _glassCircle(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _specItem(IconData icon, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: kPrimary),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
