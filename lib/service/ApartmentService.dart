import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // تأكد من إضافته
import '../core/api/dio_consumer.dart';
import '../core/api/end_points.dart';
import '../core/errors/error_model.dart';
import '../core/errors/exceptions.dart';
import '../model/apartment_model.dart';
import '../model/filter_model.dart';
import '../model/governorate_model.dart';

class ApartmentService {
  final DioConsumer api;

  ApartmentService({required this.api});

  // Get All Apartments
  Future<List<Apartment>> getAllApartments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final response = await api.dio.get(
        EndPoint.getApartments,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data.containsKey("data")) {
          final List list = data["data"];
          return list.map((e) => Apartment.fromJson(e)).toList();
        } else {
          throw ServerException(
            errModel: ErrorModel(
              errorMessage: "Invalid data format from server",
            ),
          );
        }
      } else {
        final errorMsg =
            response.data["message"] ?? "Failed to fetch apartments";
        throw ServerException(errModel: ErrorModel(errorMessage: errorMsg));
      }
    } on DioException catch (e) {
      throw ServerException(
        errModel: ErrorModel(errorMessage: "Network error: ${e.message}"),
      );
    }
  }

  //-------
  Future<List<Apartment>> getApartmentsByQuery({
    int? maxRent,
    String? orderBy,
  }) async {
    try {
      final response = await api.dio.get(
        EndPoint.getApartments,
        queryParameters: {
          if (maxRent != null) 'max_rent': maxRent,
          if (orderBy != null) 'order_by': orderBy,
        },
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode == 200) {
        final List list = response.data['data'];
        return list.map((e) => Apartment.fromJson(e)).toList();
      }

      return [];
    } on DioException {
      return [];
    }
  }
  // ApartmentService.dart

  Future<List<GovernorateModel>> getGovernorates() async {
    try {
      final response = await api.dio.get(
        EndPoint.getGovernorates,
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode == 200) {
        final List list = response.data['data'];
        return list.map((e) => GovernorateModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load governorates");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get All Apartments with Pagination and Filtering
  Future<Map<String, dynamic>> getApartments({
    FilterModel? filter,
    int page = 1,
    int limit = 10,
    bool refresh = true,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      // بناء query parameters
      Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      // إضافة الفلاتر إذا كانت موجودة
      if (filter != null) {
        queryParams.addAll(filter.toQuery());
      }

      final response = await api.dio.get(
        EndPoint.getApartments,
        queryParameters: queryParams,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data.containsKey("data")) {
          // تحويل البيانات إلى قائمة شقق
          final List list = data["data"];
          final List<Apartment> apartments = list
              .map((e) => Apartment.fromJson(e))
              .toList();

          // استخراج بيانات الـ pagination
          final int currentPage = data["current_page"] ?? 1;
          final int totalPages = data["last_page"] ?? 1;
          final int totalItems = data["total"] ?? apartments.length;
          final bool hasMore = currentPage < totalPages;

          return {
            'apartments': apartments,
            'current_page': currentPage,
            'total_pages': totalPages,
            'total_items': totalItems,
            'has_more': hasMore,
          };
        } else {
          throw ServerException(
            errModel: ErrorModel(
              errorMessage: "Invalid data format from server",
            ),
          );
        }
      } else {
        final errorMsg =
            response.data["message"] ?? "Failed to fetch apartments";
        throw ServerException(errModel: ErrorModel(errorMessage: errorMsg));
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      throw ServerException(
        errModel: ErrorModel(errorMessage: "Network error: ${e.message}"),
      );
    }
  }

  // Get Featured Apartments (مثال: الإيجار أقل من 200)

  // Search Apartments
  Future<List<Apartment>> searchApartments(String query) async {
    try {
      final response = await getApartments(
        filter: FilterModel(search: query),
        page: 1,
        limit: 10,
      );
      return response['apartments'] as List<Apartment>;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> createApartment({
    required String title,
    required String description,
    required double rentValue,
    required int rooms,
    required double space,
    required String notes,
    required int governorateId,
    required int? cityId,
    required String street,
    required String flatNumber,
    required int? longitude,
    required int? latitude,
    required List<XFile> houseImages,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      // FormData
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'rent_value': rentValue,
        'rooms': rooms,
        'space': space,
        'notes': notes,
        'governorate_id': governorateId,
        'city_id': cityId,
        'street': street,
        'flat_number': flatNumber,
        if (longitude != null) 'longitude': longitude,
        if (latitude != null) 'latitude': latitude,
      });

      for (var image in houseImages) {
        formData.files.add(
          MapEntry(
            'house_images[]',
            await MultipartFile.fromFile(image.path, filename: image.name),
          ),
        );
      }

      final response = await api.dio.post(
        EndPoint.createApartment,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        final errorMsg =
            response.data["message"] ?? "Failed to create apartment";
        throw ServerException(errModel: ErrorModel(errorMessage: errorMsg));
      }
    } on DioException catch (e) {
      throw ServerException(
        errModel: ErrorModel(errorMessage: "Network error: ${e.message}"),
      );
    }
  }

  Future<void> toggleFavorite(int houseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      await api.dio.post(
        EndPoint.toggleFavorite,
        data: {"house_id": houseId},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) => true,
        ),
      );
    } on DioException catch (e) {
      throw Exception("Failed to toggle favorite: ${e.message}");
    }
  }
}
