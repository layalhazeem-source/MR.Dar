class GovernorateModel {
  final int id;
  final String nameEn;
  final String nameAr;

  GovernorateModel({required this.id, required this.nameEn, required this.nameAr});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? {};
    return GovernorateModel(
      id: json['id'],
      nameEn: name['en'] ?? '',
      nameAr: name['ar'] ?? '',
    );
  }
}