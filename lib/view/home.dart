import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../controller/UserController.dart';
import '../controller/homecontroller.dart';
import '../core/theme/theme_service.dart';
import 'MyApartments.dart';
import 'add_apartment_page.dart';
import 'homeContent.dart';
import 'favourite.dart';
import 'myAccount.dart';
import 'myRent.dart';
import 'notifications_page.dart';
import '../controller/notification_controller.dart';
import 'owner_reservations_page.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController controller = Get.find<HomeController>();
  final ThemeService themeService = Get.find();
  final UserController user = Get.find<UserController>();
  final NotificationController notificationController =
      Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = controller.currentIndex.value;

      return Scaffold(
        appBar: _buildAppBar(context,currentIndex),
        body: _buildIndexedStack(),
        bottomNavigationBar: _buildBottomNavigationBar(context),

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

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }

  // ========================= AppBar =========================
  AppBar _buildAppBar(BuildContext context, int index) {
    String title;
    final isOwner = user.isOwner;

    if (index == 0) {
      title = 'MR.Dar';
    } else if (index == 1) {
      title = isOwner ? 'Requests'.tr : 'My Rents'.tr;
    } else if (index == 2) {
      title = isOwner ? 'My Apartments'.tr : 'Favourite'.tr;
    } else if (index == 3) {
      title = isOwner ? 'Favourite'.tr : 'My Account'.tr;
    } else {
      title = 'My Account'.tr;
    }

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: index == 0
          ? [
              // 🔔 زر الإشعارات
              Obx(() {
                final hasNotifications =
                    notificationController.notifications.isNotEmpty;

                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {
                        Get.to(() => NotificationsPage());
                      },
                    ),

                    // 🔴 Badge
                    if (hasNotifications)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                );
              }),
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
          : [],
    );
  }

  // ========================= Body =========================
  Widget _buildIndexedStack() {
    return Obx(() {
      return IndexedStack(
        index: controller.currentIndex.value,
        children: user.isOwner
            ? [
          HomeContent(),
          OwnerReservationsPage(), // 👈 الجديدة
          MyApartments(),
          Favourite(),
          MyAccount(),
        ]

            : [HomeContent(), MyRent(), Favourite(), MyAccount()],
      );
    });
  }

  // ========================= BottomNavigationBar =========================
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Obx(() {
      final isOwner = user.isOwner;

      return BottomNavigationBar(
        key: ValueKey(Get.locale?.languageCode), // 🔥 مهم
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
        Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        items: isOwner ? _ownerItems() : _renterItems(),
      );
    });
  }

  // ========================= Nav Items =========================
  List<BottomNavigationBarItem> _renterItems() => [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: "Home".tr,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark_added_outlined),
      activeIcon: Icon(Icons.bookmark_added),
      label: "My Rents".tr,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_border),
      activeIcon: Icon(Icons.favorite),
      label: "Favourite".tr,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_2_outlined),
      activeIcon: Icon(Icons.person_2),
      label: "Account".tr,
    ),
  ];

  List<BottomNavigationBarItem> _ownerItems() => [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: "Home".tr,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment_outlined),
      activeIcon: Icon(Icons.assignment_turned_in),
      label: "Requests".tr,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book_outlined),
      activeIcon: Icon(Icons.book_rounded),
      label: "My Apartments".tr,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_border),
      activeIcon: Icon(Icons.favorite),
      label: "Favourite".tr,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_2_outlined),
      activeIcon: Icon(Icons.person_2),
      label: "Account".tr,
    ),
  ];

}
