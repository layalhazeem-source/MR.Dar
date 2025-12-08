import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/apartment_model.dart';
import '../widgets/apartment_card.dart';
import 'apartment_details_page.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // شقق وهمية للتجربة
  List<Apartment> apartments = [
    Apartment(
      title: "شقة فاخرة في دمشق",
      description: "شقة مفروشة وحديثة للإيجار الشهري.",
      rentValue: 2500000,
      rooms: 3,
      space: 150,
      notes: "قريبة من الخدمات وإطلالة جميلة",
      cityId: 1,
      governorateId: 1,
      street: "أبو رمانة",
      flatNumber: "12",
      longitude: 36.2783,
      latitude: 33.5138,
      houseImages: [
        'images/photo_2025-11-30_12-36-36.jpg', // ✅ مسار الصورة المحلية

      ],
    ),
    Apartment(
      title: "شقة جميلة في حمص",
      description: "مناسبة للعائلات الصغيرة.",
      rentValue: 1500000,
      rooms: 2,
      space: 90,
      notes: "منطقة هادئة",
      cityId: 2,
      governorateId: 2,
      street: "الغوطة",
      flatNumber: "8",
      longitude: 36.72,
      latitude: 34.73,
      houseImages: [
        'images/photo_2025-11-30_12-36-36.jpg', // استخدمي نفس الصورة أو صورة ثانية محلية
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط البحث
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              hintText: "Search properties...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 90),

          // قائمة الشقق أفقية
          SizedBox(
            height: 380, // ارتفاع الكارد
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: apartments.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 300, // عرض الكارد
                  child: ApartmentCard(
                    apartment: apartments[index],
                    onTap: () {
                      Get.to(() => ApartmentDetailsPage(
                        apartment: apartments[index],
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
