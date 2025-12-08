import 'package:flutter/material.dart';

import '../model/apartment_model.dart';

class ApartmentDetailsPage extends StatelessWidget {
  final Apartment apartment;
  const ApartmentDetailsPage({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(apartment.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: PageView(
                children: apartment.houseImages.isNotEmpty
                    ? apartment.houseImages.map((img) => Image.network(img, fit: BoxFit.cover)).toList()
                    : [Image.network('https://via.placeholder.com/400', fit: BoxFit.cover)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${apartment.rentValue}/night', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${apartment.street}, City ID: ${apartment.cityId}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('${apartment.rooms} Beds · ${apartment.space} m²', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Text(apartment.description),
                  const SizedBox(height: 8),
                  Text('Notes: ${apartment.notes}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
