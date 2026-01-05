import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/view/rate_apartment_page.dart';
import '../controller/my_rents_controller.dart';
import '../core/enums/reservation_status.dart';
import '../model/reservation_model.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class MyRent extends StatefulWidget {
  const MyRent({super.key});

  @override
  State<MyRent> createState() => _MyRentState();
}

class _MyRentState extends State<MyRent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = controller.highlightedReservationId.value;

      if (id != null) {
        controller.scrollToReservation(id);
      }
    });
  }

  final MyRentsController controller = Get.find<MyRentsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ----------- Status Tabs -----------
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: ReservationStatus.values.map((status) {
                  final isSelected = controller.currentStatus.value == status;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status.displayName),
                      selected: isSelected,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
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

          // ----------- Reservation List -----------
          Expanded(
            child: Obx(() {
              // 1️⃣ Loading
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2️⃣ Error
              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              final reservations = controller.filteredReservations;

              // 3️⃣ Empty
              if (reservations.isEmpty) {
                return Center(
                  child: Text(
                    'no ${controller.currentStatus.value.displayName} reservations'
                        .tr,
                  ),
                );
              }

              // 4️⃣ List
              return ListView.builder(
                controller: controller.scrollController,

                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final reservation = reservations[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        ApartmentCard(
                          apartment: reservation.apartment,
                          onTap: () {
                            Get.to(
                              () => ApartmentDetailsPage(
                                apartment: reservation.apartment,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        if (controller.currentStatus.value ==
                            ReservationStatus.previous)
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.to(
                                  () => RateApartmentPage(
                                    houseId: reservation.apartment.id,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              label: const Text(
                                "Rate",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                shadowColor: Colors.black.withOpacity(0.3),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),

                        // 🔽 نضيف أزرار التعديل والإلغاء للـ Pending فقط
                        if (controller.currentStatus.value ==
                            ReservationStatus.pending)
                          _buildPendingActions(reservation),
                      ],
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

  Widget _buildPendingActions(ReservationModel reservation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // زر التعديل
          ElevatedButton.icon(
            onPressed: () => controller.editReservation(reservation),
            icon: const Icon(Icons.edit, size: 16),
            label: Text("Edit".tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),

          const SizedBox(width: 8),

          // زر الإلغاء
          ElevatedButton.icon(
            onPressed: () => _showCancelDialog(reservation.id),
            icon: const Icon(Icons.close, size: 16),
            label: Text("CANCEL".tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(int reservationId) {
    Get.defaultDialog(
      title: "Cancel Reservation".tr,
      middleText: "Are you sure you want to cancel this reservation?".tr,
      textConfirm: "Yes, Cancel".tr,
      textCancel: "No".tr,
      buttonColor: Theme.of(context).colorScheme.error,
      confirmTextColor: Theme.of(context).colorScheme.onError,
      onConfirm: () {
        Get.back();
        controller.cancelReservation(reservationId);
      },
    );
  }
}
