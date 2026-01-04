import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/review_controller.dart';

class RateApartmentPage extends StatelessWidget {
  final int houseId;

  RateApartmentPage({required this.houseId, super.key});

  final ReviewController controller = Get.put(
    ReviewController(service: Get.find()),
  );

  @override
  Widget build(BuildContext context) {
    controller.checkIfCanRate(houseId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Apartment"),
        backgroundColor: const Color(0xFF274668),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.canRate.value) {
          return const Center(
            child: Text(
              "You cannot rate this apartment",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your Rating",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ⭐⭐⭐⭐ النجوم
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return IconButton(
                      onPressed: () {
                        controller.rating.value = starIndex;
                      },
                      icon: Icon(
                        Icons.star,
                        size: 40,
                        color: controller.rating.value >= starIndex
                            ? Colors.amber
                            : Colors.grey[300],
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 30),

              // زر ارسال التقييم
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await controller.submitReview(houseId);

                    if (success) {
                      Get.back();
                      Get.snackbar(
                        "Success",
                        "Review added successfully",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        "Error",
                        "Failed to add review",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF274668),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
