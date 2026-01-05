import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../controller/UserController.dart';
import '../controller/my_account_controller.dart';
import '../model/apartment_model.dart';
import 'booking_date_page.dart';

class ApartmentDetailsPage extends StatelessWidget {
  final Apartment apartment;
  ApartmentDetailsPage({super.key, required this.apartment});

  final user = Get.find<UserController>();
  final apartmentController = Get.find<ApartmentController>();
  final PageController _pageController = PageController();
  final RxInt currentImageIndex = 0.obs;
  final account = Get.find<MyAccountController>();

  static const kPrimary = Color(0xFF274668);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        context: context,
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
                      context: context,
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
                      context: context,
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
              decoration:  BoxDecoration(
                color:Theme.of(context).colorScheme.surface,
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
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
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
                            color: isFav ? Colors.red : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                       Icon(Icons.location_on,
                          size: 18, color: Theme.of(context).colorScheme.primary),
                       SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${apartment.street}, ${apartment.cityName}, ${apartment.governorateName}",
                          style: TextStyle(
                            fontSize: 14,
                            color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                      _specItem(context,Icons.bed, "Rooms".tr,
                          "${apartment.rooms}"),
                      _specItem(context,Icons.square_foot, "Space".tr,
                          "${apartment.space} m²".tr),
                      _specItem(context,Icons.wifi, "Wi-Fi".tr, "Available".tr),
                      _specItem(context,Icons.apartment, "Type".tr, "Apartment".tr),
                    ],
                  ),

                  const SizedBox(height: 28),

                   Text(
                    "About This House".tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    apartment.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 24),

                   Text(
                    "Flat Number".tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    apartment.flatNumber,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),

                  // ================= PRICE + BUTTON =================
                  if (!user.isOwner)
                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
                        ),
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
                            style:  TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
      {required BuildContext context, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.5 : 0.45
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _specItem(BuildContext context, IconData icon, String title, String value) {
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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.12), // icon bg
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18,color: Theme.of(context).colorScheme.primary, // icon color
            ),
          ),
          const SizedBox(width: 10),

          /// 👇 المهم
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
