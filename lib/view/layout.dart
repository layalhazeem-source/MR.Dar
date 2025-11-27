// common_layout.dart
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final Widget child; // المحتوى الخاص بكل صفحة (form, fields, buttons, ...)
  const Layout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFFDFA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // اللّوغو
              Center(
                child: SizedBox(
                  height: 200,
                  width: 300,
                  child: Image.asset(
                    "images/photo_2025-11-27_11-23-04.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ⬅️⬅️ إضافة child هون (كان ناقص)
              child,
            ],
          ),
        ),
      ),
    );
  }
}
