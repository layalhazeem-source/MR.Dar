import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../controller/UserController.dart';
import '../controller/authcontroller.dart';
import '../controller/homecontroller.dart';
import '../core/theme/theme_service.dart';
import 'MyBooking.dart';
import 'add_apartment_page.dart';
import 'homeContent.dart';
import 'favourite.dart';
import 'myAccount.dart';
import 'myRent.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController controller = Get.put(HomeController());
  final ThemeService themeService = Get.find();
  final UserController user = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = controller.currentIndex.value;

      return Scaffold(
        appBar: _buildAppBar(currentIndex),
        body: _buildIndexedStack(),
        bottomNavigationBar: _buildBottomNavigationBar(),

        // ➕ زر إضافة شقة (Owner فقط)
        floatingActionButton: user.isOwner && controller.currentIndex.value == 0
            ? FloatingActionButton(
                backgroundColor: const Color(0xFF274668),
                onPressed: () {
                  Get.to(() => AddApartmentPage());
                },
                child: const Icon(Icons.add),
              )
            : null,

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }

  // ========================= AppBar =========================
  AppBar _buildAppBar(int index) {
    String title;

    if (index == 0) {
      title = 'MR.Dar';
    } else if (index == 1) {
      title = user.isOwner ? 'My Booking' : 'My Rents';
    } else if (index == 2) {
      title = 'Favourite';
    } else {
      title = 'My Account';
    }

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF274668),
      centerTitle: true,
      actions: index == 0
          ? [
              Obx(() {
                final isDark = themeService.rxIsDark.value;
                return IconButton(
                  onPressed: themeService.toggleTheme,
                  icon: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    size: 22,
                  ),
                );
              }),
            ]
          : index == 2
          ? [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  final apartmentController = Get.find<ApartmentController>();

                  await apartmentController.loadFavorites();

                  Get.snackbar(
                    "Refreshed",
                    "Favorites list updated",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 1),
                  );
                },
              ),
            ]
          : [],
    );
  }

  // ========================= Body =========================
  Widget _buildIndexedStack() {
    return Obx(() {
      return IndexedStack(
        index: controller.currentIndex.value,
        children: user.isOwner
            ? [HomeContent(), MyBooking(), Favourite(), MyAccount()]
            : [HomeContent(), MyRent(), Favourite(), MyAccount()],
      );
    });
  }

  // ========================= BottomNavigationBar =========================
  Widget _buildBottomNavigationBar() {
    return Obx(() {
      return BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF274668),
        unselectedItemColor: Colors.black45,
        items: user.isOwner ? _ownerItems : _renterItems,
      );
    });
  }

  // ========================= Nav Items =========================
  final List<BottomNavigationBarItem> _renterItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark_added_outlined),
      activeIcon: Icon(Icons.bookmark_added),
      label: "My Rents",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_border),
      activeIcon: Icon(Icons.favorite),
      label: "Favourite",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_2_outlined),
      activeIcon: Icon(Icons.person_2),
      label: "Account",
    ),
  ];

  final List<BottomNavigationBarItem> _ownerItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book_outlined),
      activeIcon: Icon(Icons.book_rounded),
      label: "My Booking",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_border),
      activeIcon: Icon(Icons.favorite),
      label: "Favourite",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_2_outlined),
      activeIcon: Icon(Icons.person_2),
      label: "Account",
    ),
  ];
}
