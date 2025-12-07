import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // مسح التوكن
    Get.offAll(() => Login()); // الانتقال لشاشة Login ومسح تاريخ الصفحات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF274668),
        unselectedItemColor: Colors.black45,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_added_outlined),
            label: "My Rents",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Favourite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "My account",
          ),
        ],
      ),
      appBar: AppBar(
        title: const Center(child: Text('MR.Dar')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // زر تسجيل الخروج
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF274668)),
              child: Center(
                child: Text(
                  'Drawer Header',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_sharp),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout, // نفس الزر بالـ Drawer
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SearchBar(
          leading: SizedBox(
            width: 40,
            child: Icon(Icons.search, color: Colors.grey[400]),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          hintText: "Search",
          hintStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.grey),
          ),
          textStyle: MaterialStateProperty.all(
            const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
