import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../model/apartment_model.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback onTap;

  const ApartmentCard({
    super.key,
    required this.apartment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApartmentController>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.3 : 0.06,
                ),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Image =====
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      apartment.houseImages.isNotEmpty
                          ? apartment.houseImages.first
                          : "",
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          color: Theme.of(context).colorScheme.surface,
                          child: Center(
                            child: Icon(
                              Icons.home,
                              size: 60,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 160,
                          color:colors.surface,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Obx(() {
                      final isFav = controller.isFavorite(apartment.id);

                      return GestureDetector(
                        onTap: () async {
                          // إظهار مؤشر تحميل صغير
                          Get.showSnackbar(
                            GetSnackBar(
                              message: isFav
                                  ? "Removing from favorites...".tr
                                  : "Adding to favorites...".tr,
                              duration: const Duration(seconds: 1),
                              backgroundColor: colors.surface,
                            ),
                          );

                          try {
                            await controller.toggleFavorite(apartment.id);

                            // رسالة نجاح
                            Get.showSnackbar(
                              GetSnackBar(
                                message: isFav
                                    ? "Removed from favorites".tr
                                    : "Added to favorites".tr,
                                duration: const Duration(seconds: 1),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            Get.showSnackbar(
                              GetSnackBar(
                                message: "Failed to update favorites".tr,
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isFav ? Colors.red : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              // ===== Content =====
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      apartment.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Location (city + governorate)
                    Row(
                      children: [
                         Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color:Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${apartment.cityName}, ${apartment.governorateName}",
                            style: TextStyle(
                              fontSize: 12,
                              color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Price + Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${apartment.rentValue} / month".tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:  Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          onPressed: onTap,
                          child: Text(
                            "View".tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
