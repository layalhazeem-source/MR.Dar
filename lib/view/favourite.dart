import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../model/apartment_model.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  final ApartmentController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.loadFavorites(); // تحميل المفضلة عند فتح الصفحة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorites"),
        backgroundColor: Color(0xFF274668),
      ),
      body: Obx(() {
        if (controller.favoriteApartments.isEmpty) {
          return Center(child: Text("No favorites yet"));
        }

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: controller.favoriteApartments.length,
          itemBuilder: (context, index) {
            final apartment = controller.favoriteApartments[index];
            return ApartmentCard(
              apartment: apartment,
              onTap: () {
                Get.to(() => ApartmentDetailsPage(apartment: apartment));
              },
            );
          },
        );
      }),
    );
  }
}
