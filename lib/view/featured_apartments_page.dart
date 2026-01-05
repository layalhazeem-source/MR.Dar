import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/apartment_card.dart';
import '../model/apartment_model.dart';
import 'apartment_details_page.dart';

class FeaturedApartmentsPage extends StatelessWidget {
  final List<Apartment> apartments;

  const FeaturedApartmentsPage({
    super.key,
    required this.apartments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title:  Text("Featured Apartments".tr),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: apartments.length,
        itemBuilder: (context, index) {
          final apt = apartments[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ApartmentCard(
              apartment: apt,
              onTap: () {
                Get.to(
                      () => ApartmentDetailsPage(apartment: apt),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
