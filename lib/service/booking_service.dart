import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/dio_consumer.dart';
import '../core/api/end_points.dart';
import '../model/booking_model.dart';

class BookingService {
  final DioConsumer api;

  BookingService({required this.api});

  /// 🟢 جلب الحجوزات لبيت معين
  Future<List<Booking>> getHouseReservations(int houseId) async {
    final response = await api.dio.get(
      '${EndPoint.reservations}/house/$houseId',
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode == 200) {
      final List list = response.data['data'];
      return list.map((e) => Booking.fromJson(e)).toList();
    }
    return [];
  }

  /// 🟢 إنشاء حجز
  Future<bool> createReservation({
    required int houseId,
    required String startDate,
    required int duration,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final response = await api.dio.post(
      EndPoint.reservations,
      data: {
        "house_id": houseId,
        "start_date": startDate,
        "duration": duration,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        validateStatus: (_) => true,
      ),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
