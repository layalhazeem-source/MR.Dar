import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/UserController.dart';
import '../model/apartment_model.dart';

class ApartmentDetailsPage extends StatelessWidget {
  final Apartment apartment;
  final user = Get.find<UserController>();

   ApartmentDetailsPage({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar مع زر رجوع وعنوان

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- صور الشقة ----------
            Container(
              height: 300,
              child: Stack(
                children: [
                  // الصور
                  PageView.builder(
                    itemCount: apartment.houseImages.length,
                    itemBuilder: (_, index) {
                      return Image.network(
                        apartment.houseImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: _circleIcon(Icons.arrow_back_ios_new, () => Get.back()),
                  ),

                  Positioned(
                    top: 40,
                    right: 16,
                    child: _circleIcon(Icons.favorite_border, () {}),
                  ),

                ],
              ),
            ),

            // ---------- المحتوى ----------
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان والسعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          apartment.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "\$${apartment.rentValue}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF274668),
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 16),

                  // الموقع
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Color(0xFF274668)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                            "${apartment.street}, ${apartment.cityName}, ${apartment.governorateName}",
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // المواصفات الأساسية
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _specsItem(Icons.bed, "${apartment.rooms} Bedrooms"),
                        _specsItem(Icons.square_foot, "${apartment.space} m²"),
                        _specsItem(Icons.apartment, "Apartment"),
                        _specsItem(Icons.wifi, "wifi"),

                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // الوصف
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    apartment.description.isNotEmpty
                        ? apartment.description
                        : "A beautiful apartment with modern amenities and comfortable living space.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    "Flat Num",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),

                  if (apartment.flatNumber.isNotEmpty)
                    Text(
                      apartment.flatNumber,
                      style: TextStyle( fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,),
                    ),



                  SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      // ---------- زر book ----------
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !user.isOwner
          ? Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF274668),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // Get.to(() => BookingPage(apartment: apartment));
          },
          child: const Text(
            "Book Now",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      )
          : null,

    );
  }
  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _specsItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Color(0xFF274668)),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}