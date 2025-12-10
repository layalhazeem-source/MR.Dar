import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final ApartmentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.apartments.isEmpty) {
                return const Center(
                  child: Text(
                    "No apartments available",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return GridView.builder(
                itemCount: controller.apartments.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final apt = controller.apartments[index];
                  return ApartmentCard(
                    apartment: apt,
                    onTap: () {
                      Get.to(
                            () => ApartmentDetailsPage(apartment: apt),
                      );
                    },
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
