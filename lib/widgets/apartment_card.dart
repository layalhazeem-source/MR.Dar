import 'package:flutter/material.dart';

import '../model/apartment_model.dart';

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;
  final VoidCallback onTap;

  const ApartmentCard({super.key, required this.apartment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    apartment.houseImages.isNotEmpty
                        ? apartment.houseImages[0]
                        : 'https://via.placeholder.com/400',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Colors.red, size: 28),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${apartment.rentValue}/night', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('${apartment.street}, ${apartment.cityId}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('${apartment.rooms} Beds · ${apartment.space} m²', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
