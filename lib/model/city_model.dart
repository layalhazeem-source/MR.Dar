class CityModel {
  final int id;
  final String nameEn;
  final String nameAr;

  CityModel({required this.id, required this.nameEn, required this.nameAr});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? {};
    return CityModel(
      id: json['id'],
      nameEn: name['en'] ?? '',
      nameAr: name['ar'] ?? '',
    );
  }
}