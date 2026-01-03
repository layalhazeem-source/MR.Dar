class AppNotification {
  final String type;
  final int reservationId;
  final int houseId;
  final String status;
  final String title;
  final String message;

  // 🔥 الجدد
  final String? house;
  final String? date;
  final String? time;

  AppNotification({
    required this.type,
    required this.reservationId,
    required this.houseId,
    required this.status,
    required this.title,
    required this.message,
    this.house,
    this.date,
    this.time,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      type: json['type'],
      reservationId: json['reservation_id'],
      houseId: json['house_id'],
      status: json['status'],
      title: json['title'],
      message: json['message'],

      // 👇 الجدد
      house: json['house'],
      date: json['date'],
      time: json['time'],
    );
  }
}
