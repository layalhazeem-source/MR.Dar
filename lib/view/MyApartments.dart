import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/my_apartments_controller.dart';
import '../core/enums/apartment_status.dart';

class MyApartments extends StatefulWidget {
  const MyApartments({super.key});

  @override
  State<MyApartments> createState() => _MyApartmentsState();
}

class _MyApartmentsState extends State<MyApartments> {
  final MyApartmentsController controller =
  Get.put(MyApartmentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // -------- Status Tabs --------
          Obx(
                () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: ApartmentStatus.values.map((status) {
                  final isSelected =
                      controller.currentStatus.value == status;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status.displayName),
                      selected: isSelected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (_) => controller.changeStatus(status),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // -------- Apartments List --------
          Expanded(
            child: Obx(() {
              final apartments = controller.filteredApartments;

              if (apartments.isEmpty) {
                return const Center(
                  child: Text('no apartments'),
                );
              }

              return ListView.builder(
                itemCount: apartments.length,
                itemBuilder: (context, index) {
                  final apartment = apartments[index];

                  return ListTile(
                    leading: apartment.houseImages.isNotEmpty
                        ? Image.network(
                      apartment.houseImages.first,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.apartment),
                    title: Text(apartment.title),
                    subtitle: Text(
                      '${apartment.cityName} - ${apartment.governorateName}',
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}