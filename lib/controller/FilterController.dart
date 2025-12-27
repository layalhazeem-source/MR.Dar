import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../model/apartment_model.dart';
import '../model/filter_model.dart';
import '../service/ApartmentService.dart';

class FilterController extends GetxController {
  final dio = Dio();
  final ApartmentService apiService = Get.find();
  var searchResults = <Apartment>[].obs;
  var isSearching = false.obs;
  // Rx لملاحظة التغييرات
  final Rx<FilterModel> currentFilter = FilterModel().obs;


  // تطبيق فلتر جديد
  void applyFilter(FilterModel filter) {
    currentFilter.value = filter;
    update();
  }

  // تحديث جزئي للفلتر
  void updateFilter({
    String? search,
    int? governorateId,
    int? cityId,
    int? minRent,
    int? maxRent,
    int? minRooms,
    int? maxRooms,
    int? minSpace,
    int? maxSpace,
    String? sortBy,
    String? sortDir,
  }) {
    currentFilter.value = currentFilter.value.copyWith(
      search: search,
      governorateId: governorateId,
      cityId: cityId,
      minRent: minRent,
      maxRent: maxRent,
      minRooms: minRooms,
      maxRooms: maxRooms,
      minSpace: minSpace,
      maxSpace: maxSpace,
      sortBy: sortBy,
      sortDir: sortDir,
    );
    update();
  }

  // إعادة تعيين الفلتر
  void resetFilter() {
    currentFilter.value = FilterModel();
    update();
  }


  // ------------------- دالة البحث -------------------
  void searchApartments(String query) async {
    if (query.length < 2) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final response = await dio.get('/apartments', queryParameters: {
        'search': query,
      });

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        searchResults.value =
            data.map((e) => Apartment.fromJson(e)).toList();
      } else {
        searchResults.clear();
      }
    } catch (e) {
      searchResults.clear();
      print("Search error: $e");
    } finally {
      isSearching.value = false;
    }
  }
}