import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Image ----------
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: apartment.houseImages.isNotEmpty
                      ? Image.network(
                    apartment.houseImages.first,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: const Icon(Icons.home, size: 50),
                  ),
                ),

                // Favorite
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border,
                          color: Colors.white, size: 18),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),

            // ---------- Content ----------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    apartment.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height:10),

                  // Location
                  Text(
                    "${apartment.street}, ${apartment.cityName}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),


                  const SizedBox(height: 9),

                  // Price
                  Text(
                    "\$${apartment.rentValue} / month",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
