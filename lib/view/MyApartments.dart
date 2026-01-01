import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/my_apartments_controller.dart';
import '../core/enums/apartment_status.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class MyApartments extends StatefulWidget {
  const MyApartments({super.key});

  @override
  State<MyApartments> createState() => _MyApartmentsState();
}

class _MyApartmentsState extends State<MyApartments> {
  final MyApartmentsController controller = Get.find<MyApartmentsController>();

  @override
  void initState() {
    super.initState();
    // Refresh data when page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMyApartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Apartments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchMyApartments(),
          ),
        ],
      ),
      body: Column(
        children: [
          // -------- Status Tabs --------
          Container(
            color: Colors.grey[50],
            child: Obx(
                  () {
                // 🔴 **استخدام الدالة الجديدة لحساب العدد**
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: ApartmentStatus.values.map((status) {
                      final isSelected = controller.currentStatus.value == status;
                      // 🔴 **استخدام getApartmentCountByStatus**
                      final count = controller.getApartmentCountByStatus(status);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(status.displayName),
                              if (count > 0) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    count.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected ? Colors.white : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          selected: isSelected,
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (_) => controller.changeStatus(status),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),

          // -------- Apartments List --------
          Expanded(
            child: Obx(() {
              // 1️⃣ Loading
              if (controller.isLoading.value && controller.allApartments.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // 2️⃣ Error
              if (controller.errorMessage.isNotEmpty &&
                  controller.allApartments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => controller.fetchMyApartments(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final apartments = controller.filteredApartments;

              // 3️⃣ Empty
              if (apartments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.apartment,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No apartments in ${controller.currentStatus.value.displayName}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (controller.currentStatus.value != ApartmentStatus.pending)
                        ElevatedButton(
                          onPressed: () => controller.changeStatus(ApartmentStatus.pending),
                          child: const Text('View Pending Apartments'),
                        ),
                    ],
                  ),
                );
              }

              // 4️⃣ List
              return RefreshIndicator(
                onRefresh: () => controller.fetchMyApartments(),
                child: ListView.builder(
                  itemCount: apartments.length,
                  itemBuilder: (context, index) {
                    final apartment = apartments[index];
                    final status = ApartmentStatusExtension.fromDynamic(
                      apartment.apartmentStatus,
                    );

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          // Status Badge
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: status.color,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  status.displayName.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${apartment.rentValue} SYP',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Apartment Card
                          ApartmentCard(
                            apartment: apartment,
                            onTap: () {
                              Get.to(() => ApartmentDetailsPage(apartment: apartment));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
  Color _getStatusColor(ApartmentStatus status) {
    switch (status) {
      case ApartmentStatus.pending:
        return Colors.orange;
      case ApartmentStatus.accepted:
        return Colors.green;
      case ApartmentStatus.rejected:
        return Colors.red;
      case ApartmentStatus.blocked:
        return Colors.grey;
      case ApartmentStatus.canceled:
        return Colors.purple;
    }
  }
