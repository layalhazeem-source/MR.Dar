class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String role;
  final String dateOfBirth;
  final String? profileImage;
  final String? idImage;

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
    return UserModel(
      id: int.parse(json['id'].toString()),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'].toString(),
      dateOfBirth: json['date_of_birth'] ?? '',
      profileImage:
          (json["profile_image"] != null && json["profile_image"] is Map)
          ? json["profile_image"]["url"]?.toString()
          : null,
      idImage: (json["id_image"] != null && json["id_image"] is Map)
          ? json["id_image"]["url"]?.toString()
          : null,
    );
  }
}
