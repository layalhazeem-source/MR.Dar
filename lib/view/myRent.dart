import 'package:flutter/material.dart';

class MyRent extends StatefulWidget {
  const MyRent({super.key});

  @override
  State<MyRent> createState() => _MyRentState();
}

class _MyRentState extends State<MyRent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Rents'),
        backgroundColor: Color(0xFF274668),
        foregroundColor: Colors.white,
      ),
    );
  }
}
