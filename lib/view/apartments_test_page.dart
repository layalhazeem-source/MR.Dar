import 'package:flutter/material.dart';
import '../model/apartment_model.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class ApartmentsTestPage extends StatelessWidget {
  const ApartmentsTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data للشقق
    final apartments = [
      Apartment(
        title: "Cozy Apartment",
        description: "Nice and cozy apartment in the city center.",
        rentValue: 120,
        rooms: 3,
        space: 80,
        notes: "No pets allowed",
        cityId: 1,
        governorateId: 1,
        street: "Main Street",
        flatNumber: "12A",
        longitude: 0.0,
        latitude: 0.0,
        houseImages: ["https://via.placeholder.com/400", "https://via.placeholder.com/401"],
      ),
      Apartment(
        title: "Luxury Flat",
        description: "Spacious flat with amazing view.",
        rentValue: 200,
        rooms: 2,
        space: 100,
        notes: "Pool included",
        cityId: 1,
        governorateId: 1,
        street: "Sunset Blvd",
        flatNumber: "5B",
        longitude: 0.0,
        latitude: 0.0,
        houseImages: ["https://via.placeholder.com/402"],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Apartments Test")),
      body: ListView.builder(
        itemCount: apartments.length,
        itemBuilder: (context, index) {
          return ApartmentCard(
            apartment: apartments[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ApartmentDetailsPage(apartment: apartments[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
