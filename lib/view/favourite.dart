import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../model/apartment_model.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  final ApartmentController controller = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();

    // إضافة listener لسحب للتحديث
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // يمكن إضافة pagination هنا إذا احتجت
      }
    });
  }

  Future<void> _loadFavorites() async {
    try {
      await controller.loadFavorites();
    } catch (e) {
      print("Error loading favorites: $e");
    }
  }

  void _onApartmentTapped(Apartment apartment) {
    Get.to(() => ApartmentDetailsPage(apartment: apartment));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.favoriteApartments.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favoriteApartments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  "No favorites yet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Tap the heart icon on apartments to add them here",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back(); // العودة للصفحة الرئيسية
                  },
                  icon: const Icon(Icons.explore),
                  label: const Text("Browse Apartments"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF274668),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadFavorites,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.favoriteApartments.length,
            itemBuilder: (context, index) {
              final apartment = controller.favoriteApartments[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ApartmentCard(
                  apartment: apartment,
                  onTap: () => _onApartmentTapped(apartment),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
