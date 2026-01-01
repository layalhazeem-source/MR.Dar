class AppNotification {
  final String type;
  final int reservationId;
  final int houseId;
  final String status;
  final String title;
  final String message;

  AppNotification({
    required this.type,
    required this.reservationId,
    required this.houseId,
    required this.status,
    required this.title,
    required this.message,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      type: json['type'],
      reservationId: json['reservation_id'],
      houseId: json['house_id'],
      status: json['status'],
      title: json['title'],
      message: json['message'],
    );
  }
}
