class Apartment {
  final int id;
  final String title;
  final String description;
  final double rentValue;
  final int rooms;
  final double space;
  final String notes;
  final int cityId;
  final int governorateId;
  final String street;
  final String flatNumber;
  final double longitude;
  final double latitude;
  final List<String> houseImages;

  Apartment({
    required this.id,
    required this.title,
    required this.description,
    required this.rentValue,
    required this.rooms,
    required this.space,
    required this.notes,
    required this.cityId,
    required this.governorateId,
    required this.street,
    required this.flatNumber,
    required this.longitude,
    required this.latitude,
    required this.houseImages,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    // دالة مساعدة للتحويل الآمن
    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          return 0;
        }
      }
      if (value is double) return value.toInt();
      return 0;
    }

    double safeParseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (e) {
          return 0.0;
        }
      }
      return 0.0;
    }
    List<String> parseImages(dynamic imagesData) {
      final List<String> images = [];

      if (imagesData != null && imagesData is List) {
        for (var item in imagesData) {
          if (item is Map && item['url'] != null) {
            // استخراج الـ URL من object
            images.add(item['url'].toString());
          } else if (item is String) {
            // إذا كان string مباشرة
            images.add(item);
          }
        }
      }

      return images;
    }
    return Apartment(
      id: safeParseInt(json["id"]),
      title: json["title"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      rentValue: safeParseDouble(json["rent_value"]),
      rooms: safeParseInt(json["rooms"]),
      space: safeParseDouble(json["space"]),
      notes: json["notes"]?.toString() ?? "",
      cityId: safeParseInt(json["city_id"]),
      governorateId: safeParseInt(json["governorate_id"]),
      street: json["street"]?.toString() ?? "",
      flatNumber: json["flat_number"]?.toString() ?? "",
      longitude: safeParseDouble(json["longitude"]),
      latitude: safeParseDouble(json["latitude"]),
      houseImages: parseImages(json["images"]), // ⬅️ استخدام الـ parser الجديد

    );
  }
}