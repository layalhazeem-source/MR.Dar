import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/view/login.dart';
import 'package:new_project/view/signup.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home"), backgroundColor: Colors.pinkAccent),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 100),
          child: Column(
            children: [
              MaterialButton(
                color: Colors.pink,
                textColor: Colors.white70,
                child: Text("page two"),
                onPressed: () {
                  Get.to(Signup());
                },
              ),
              MaterialButton(
                color: Colors.pink,
                textColor: Colors.white70,
                child: Text("page three"),
                onPressed: () {
                  Get.to(Login());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
