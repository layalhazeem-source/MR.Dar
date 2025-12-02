import 'dart:collection';

import '../api/end_points.dart';

class ErrorModel {
  final int? status;
  final String errorMessage;
  final Map<String, dynamic>? errors; // جديد

  ErrorModel({this.status, required this.errorMessage, this.errors});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      status: jsonData["status"] is bool
          ? (jsonData["status"] == true ? 200 : 400)
          : jsonData["status"],
      errorMessage: jsonData["message"] ?? "Unknown Error",
      errors: jsonData["errors"], // جديد
    );
  }
}
