import 'city_model.dart';

class GovernorateModel {
  final int id;
  final String name;
  final List<CityModel> cities;

  GovernorateModel({
    required this.id,
    required this.name,
    required this.cities,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['id'],
      name: json['name'],
      cities: (json['cities'] as List)
          .map((e) => CityModel.fromJson(e))
          .toList(),
    );
  }
}
