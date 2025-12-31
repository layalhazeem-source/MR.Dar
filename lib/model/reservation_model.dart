import 'package:new_project/model/user_model.dart';

import 'apartment_model.dart';

class ReservationModel {
  final int id;
  final Apartment apartment;
  final UserModel? user; // موجود فقط عند المالك
  final String startDate;
  final String endDate;
  final int duration;
  final String status;

  ReservationModel({
    required this.id,
    required this.apartment,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.status,
    this.user,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    int safeInt(dynamic v) => v == null ? 0 : int.tryParse(v.toString()) ?? 0;

    return ReservationModel(
      id: safeInt(json['id']),
      apartment: Apartment.fromJson(json['house']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      duration: safeInt(json['duration']),
      status: json['status'] ?? '',
    );
  }

  // إضافة copyWith
  ReservationModel copyWith({
    int? id,
    Apartment? apartment,
    UserModel? user,
    String? startDate,
    String? endDate,
    int? duration,
    String? status,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      apartment: apartment ?? this.apartment,
      user: user ?? this.user,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }
}
