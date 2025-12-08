import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SearchBar(
            leading: SizedBox(
              width: 40,
              child: Icon(Icons.search, color: Colors.grey[400]),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            hintText: "Search properties...",
            hintStyle: MaterialStateProperty.all(
              const TextStyle(color: Colors.grey),
            ),
            textStyle: MaterialStateProperty.all(
              const TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
