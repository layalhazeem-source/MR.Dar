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
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: apartment.houseImages.isNotEmpty
                  ? Image.network(
                apartment.houseImages[0],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                "images/photo_2025-11-30_12-36-36.jpg",
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "\$${apartment.rentValue} / night",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700]),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${apartment.rooms} Beds • ${apartment.space} m²",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
