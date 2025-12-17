import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // تأكد من إضافته
import '../core/api/dio_consumer.dart';
import '../core/api/end_points.dart';
import '../core/errors/error_model.dart';
import '../core/errors/exceptions.dart';
import '../model/apartment_model.dart';

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

      print(" Response status: ${response.statusCode}");
      print(" Response data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data.containsKey("data")) {
          final List list = data["data"];
          return list.map((e) => Apartment.fromJson(e)).toList();
        } else {
          throw ServerException(
            errModel: ErrorModel(errorMessage: "Invalid data format from server"),
          );
        }
      } else {
        final errorMsg =
            response.data["message"] ?? "Failed to fetch apartments";
        throw ServerException(
          errModel: ErrorModel(errorMessage: errorMsg),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        errModel: ErrorModel(errorMessage: "Network error: ${e.message}"),
      );
    }
  }
//-------
  Future<List<Apartment>> getApartmentsByQuery({
    int? maxPrice,
    String? orderBy,
  }) async {
    try {
      final response = await api.dio.get(
        EndPoint.getApartments,
        queryParameters: {
          if (maxPrice != null) 'max_price': maxPrice,
          if (orderBy != null) 'order_by': orderBy,
        },
        options: Options(
          validateStatus: (status) => true,
        ),
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

  //Create New Apartment
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
    required int flatNumber,
    required int? longitude,
    required int? latitude,
    required List<XFile> houseImages,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      //  FormData
      final formData = FormData();


      formData.fields.add(MapEntry('title', title));
      formData.fields.add(MapEntry('description', description));
      formData.fields.add(MapEntry('rent_value', rentValue.toString()));
      formData.fields.add(MapEntry('rooms', rooms.toString()));
      formData.fields.add(MapEntry('space', space.toString()));
      formData.fields.add(MapEntry('notes', notes));
      formData.fields.add(MapEntry('city_id', cityId.toString()));

      formData.fields.add(MapEntry('governorate_id', governorateId.toString()));
      formData.fields.add(MapEntry('street', street));
      formData.fields.add(MapEntry('flat_number', flatNumber.toString()));




      if (longitude != null) {
        formData.fields.add(MapEntry('longitude', longitude.toString()));
      }

      if (latitude != null) {
        formData.fields.add(MapEntry('latitude', latitude.toString()));
      }


      for (int i = 0; i < houseImages.length; i++) {
        final image = houseImages[i];
        formData.files.add(
          MapEntry(
            'house_images[$i]',
            await MultipartFile.fromFile(
              image.path,
              filename: 'image_$i.jpg',
            ),
          ),
        );
      }


      final response = await api.dio.post(
        EndPoint.createApartment,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
          validateStatus: (status) => true,
        ),
      );

      print(" Create apartment response: ${response.statusCode}");
      print(" Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        final errorMsg = response.data["message"] ?? "Failed to create apartment";
        throw ServerException(
          errModel: ErrorModel(errorMessage: errorMsg),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        errModel: ErrorModel(errorMessage: "Network error: ${e.message}"),
      );
    }
  }


}