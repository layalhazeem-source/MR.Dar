class ErrorModel {
  final String errorMessage;
  final Map<String, dynamic>? errors;

  ErrorModel({required this.errorMessage, this.errors});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      errorMessage:
      jsonData["message"]?.toString() ?? jsonData["error"]?.toString() ?? "Unknown error",
      errors: jsonData["errors"],
    );
  }
}
