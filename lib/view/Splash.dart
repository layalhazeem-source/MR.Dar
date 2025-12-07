import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'WelcomePage.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkLogin();

    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    await Future.delayed(Duration(seconds: 1));

    if (token != null) {
      Get.offAll(() => Home());
    } else {
      Get.offAll(() => WelcomePage());
    }
  }
}
