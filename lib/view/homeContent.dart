import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../model/apartment_model.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  final ApartmentController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Search Bar ----------------
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
              //  onChanged: (value) => controller.search(value),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  hintText: "Search apartments...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- قسم: الشقق المميزة (أفقي) ----------------
        Obx(() {
          if (controller.featuredApartments.isEmpty) return SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Featured Apartments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.featuredApartments.length,
                  itemBuilder: (context, index) {
                    final apt = controller.featuredApartments[index];
                    return Container(
                      width: 220,
                      margin: EdgeInsets.only(right: 16),
                      child: ApartmentCard(
                        apartment: apt,
                        onTap: () {
                          Get.to(() => ApartmentDetailsPage(apartment: apt));
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

            // ---------------- قسم: الأعلى تقييماً (أفقي) ----------------
        Obx(() {
          if (controller.topRatedApartments.isEmpty) return SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Top Rated",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.topRatedApartments.length,
                  itemBuilder: (context, index) {
                    final apt = controller.topRatedApartments[index];
                    return Container(
                      width: 220,
                      margin: EdgeInsets.only(right: 16),
                      child: ApartmentCard(
                        apartment: apt,
                        onTap: () {
                          Get.to(() => ApartmentDetailsPage(apartment: apt));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),

         ],
        ),
      ),
    );
  }
}


// كارد خاص للأقسام الأفقية
