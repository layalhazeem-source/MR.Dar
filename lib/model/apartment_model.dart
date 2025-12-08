class Apartment {
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
}
