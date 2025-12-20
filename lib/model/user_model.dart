class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final String dateOfBirth;
  final String profileImage;
  final String idImage;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.dateOfBirth,
    required this.profileImage,
    required this.idImage,
  });

  // من JSON

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String parseImages(dynamic image) {
      if (image is Map && image['url'] != null) {
        return image['url'].toString();
      }
      return " ";
    }

    return UserModel(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      phone: json["phone"],
      role: json["role"],
      dateOfBirth: json["date_of_birth"],
      profileImage: parseImages(json['profile_image']),
      idImage: parseImages(json['id_image']),
    );
  }
}
