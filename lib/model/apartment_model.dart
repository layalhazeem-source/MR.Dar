import '../core/enums/apartment_status.dart';

class Apartment {
  final int id;
  final String title;
  final String description;
  final double rentValue;
  final int rooms;
  final double space;
  final String? notes;

  final int cityId;
  final String cityName;
  final int governorateId;
  final String governorateName;

  final String street;
  final String flatNumber;
  final double? longitude;
  final double? latitude;

  final String? apartmentStatus;

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
    required this.cityName,
    required this.governorateId,
    required this.governorateName,
    required this.street,
    required this.flatNumber,
    required this.longitude,
    required this.latitude,
    required this.houseImages,
    required this.apartmentStatus,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic v) =>
        v == null ? 0 : int.tryParse(v.toString()) ?? 0;

    double safeDouble(dynamic v) =>
        v == null ? 0.0 : double.tryParse(v.toString()) ?? 0.0;

    List<String> parseImages(dynamic images) {
      if (images is List) {
        return images
            .where((e) => e is Map && e['url'] != null)
            .map((e) => e['url'].toString())
            .toList();
      }
      return [];
    }

    final address = json['address'] ?? {};
    final city = address['city'] ?? {};
    final governorate = city['governorate'] ?? {};

    String? getApartmentStatus() {
      dynamic statusValue;

      if (json['house'] is Map && json['house']['status'] != null) {
        statusValue = json['house']['status'];
      } else if (json['status'] != null) {
        statusValue = json['status'];
      } else if (json['is_active'] != null) {
        final isActive = json['is_active'];
        return (isActive == 1 || isActive == true || isActive == '1')
            ? 'accepted'
            : 'pending';
      }

      // استخدم الدالة المساعدة للتحويل
      if (statusValue != null) {
        final status = ApartmentStatusExtension.fromDynamic(statusValue);
        return status.toString().split('.').last; // يحول 'ApartmentStatus.accepted' إلى 'accepted'
      }

      return 'pending';
    }
    final apartmentStatus = getApartmentStatus();

    return Apartment(
      id: safeInt(json['id']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      rentValue: safeDouble(json['rent_value']),
      rooms: safeInt(json['rooms']),
      space: safeDouble(json['space']),
      notes: json['notes'] ,

      cityId: safeInt(city['id']),
      cityName: city['name'] ?? '',
      governorateId: safeInt(governorate['id']),
      governorateName: governorate['name'] ?? '',

      street: address['street'] ?? '',
      flatNumber: address['flat_number']?.toString() ?? '',
      longitude: address['longitude'] == null
          ? null
          : double.tryParse(address['longitude'].toString()),

      latitude: address['latitude'] == null
          ? null
          : double.tryParse(address['latitude'].toString()),

      houseImages: parseImages(json['images']),
      apartmentStatus: apartmentStatus, // ✅ هنا
    );
  }
}
