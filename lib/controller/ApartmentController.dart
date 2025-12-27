import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/end_points.dart';
import '../model/apartment_model.dart';
import '../model/city_model.dart';
import '../model/filter_model.dart';
import '../model/governorate_model.dart';
import '../service/ApartmentService.dart';

class ApartmentController extends GetxController {
  final ApartmentService service;
  FilterModel filter = FilterModel();
  final TextEditingController searchController = TextEditingController();

  ApartmentController({required this.service});

  RxList<GovernorateModel> governorates = <GovernorateModel>[].obs;
  RxList<CityModel> cities = <CityModel>[].obs;
  final ApartmentService apiService = Get.find();
  RxSet<int> favoriteIds = <int>{}.obs;
  RxList<Apartment> favoriteApartments = <Apartment>[].obs;
  var searchResults = <Apartment>[].obs;
  var isSearching = false.obs;

  int? selectedGovernorateId;
  int? selectedCityId;

  // بيانات الشقق
  RxList<Apartment> allApartments = <Apartment>[].obs;
  RxList<Apartment> featuredApartments = <Apartment>[].obs;
  RxList<Apartment> topRatedApartments = <Apartment>[].obs;
  RxList<Apartment> filteredApartments = <Apartment>[].obs;

  // حالة التحميل والأخطاء
  RxBool isLoading = false.obs;
  RxBool isCreating = false.obs;
  RxBool isFilterLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString createMessage = ''.obs;

  // بيانات الـ Pagination
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalItems = 0.obs;
  RxBool hasMore = true.obs;
  RxBool isLoadingMore = false.obs;

  // Search
  RxString searchQuery = ''.obs;
  final Rx<FilterModel> currentFilter = FilterModel().obs;

  @override
  void onInit() {
    super.onInit(); // استدعاء الدالة الأصلية أولاً
    loadApartments(); // دالة تحميل الشقق
    loadInitialData(); // دالة تحميل البيانات الابتدائية
    loadGovernorates();
  }

  // تحميل البيانات الأولية
  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;

      await Future.wait([loadAllApartments()]);
    } catch (e) {
      errorMessage.value = "Failed to load initial data: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  //load apartments
  Future<void> loadApartments() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      allApartments.assignAll(await service.getAllApartments());

      featuredApartments.assignAll(
        await service.getApartmentsByQuery(maxRent: 200),
      );

      topRatedApartments.assignAll(
        await service.getApartmentsByQuery(orderBy: 'rate'),
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // تحميل كل الشقق
  Future<void> loadAllApartments({bool refresh = true}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await service.getApartments(
        filter: currentFilter.value,
        page: currentPage.value,
        limit: 10,
        refresh: refresh,
      );

      if (refresh) {
        allApartments.value = response['apartments'] as List<Apartment>;
        filteredApartments.value = response['apartments'] as List<Apartment>;
      } else {
        allApartments.addAll(response['apartments'] as List<Apartment>);
        filteredApartments.addAll(response['apartments'] as List<Apartment>);
      }

      currentPage.value = response['current_page'];
      totalPages.value = response['total_pages'];
      totalItems.value = response['total_items'];
      hasMore.value = response['has_more'];
    } catch (e) {
      errorMessage.value = "Failed to load apartments: ${e.toString()}";
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // تطبيق الفلتر
  Future<void> applyFilter(FilterModel filter) async {
    try {
      isFilterLoading.value = true;
      currentFilter.value = filter;
      currentPage.value = 1;

      final response = await service.getApartments(
        filter: filter,
        page: 1,
        limit: 10,
        refresh: true,
      );

      filteredApartments.value = response['apartments'] as List<Apartment>;
      currentPage.value = response['current_page'];
      totalPages.value = response['total_pages'];
      totalItems.value = response['total_items'];
      hasMore.value = response['has_more'];
    } catch (e) {
      errorMessage.value = "Failed to apply filter: ${e.toString()}";
    } finally {
      isFilterLoading.value = false;
    }
  }

  // البحث
  Future<void> searchApartments(String query) async {
    searchQuery.value = query;

    if (query.length < 1) {
      filteredApartments.assignAll(allApartments);
      return;
    }

    isSearching.value = true;

    try {
      final result = await service.getApartments(
        filter: FilterModel(search: query),
        page: 1,
        limit: 10,
      );

      filteredApartments.assignAll(result['apartments'] as List<Apartment>);
    } catch (e) {
      filteredApartments.assignAll([]);
      print("Search error: $e");
    } finally {
      isSearching.value = false;
    }
  }

  // Future<void> searchApartments(String query) async {
  //   try {
  //     searchQuery.value = query;
  //     currentPage.value = 1;
  //     isLoading.value = true;
  //
  //     final response = await service.searchApartments(query, page: 1);
  //
  //     filteredApartments.value = response['apartments'] as List<Apartment>;
  //     currentPage.value = response['current_page'];
  //     totalPages.value = response['total_pages'];
  //     totalItems.value = response['total_items'];
  //     hasMore.value = response['has_more'];
  //
  //   } catch (e) {
  //     errorMessage.value = "Failed to search: ${e.toString()}";
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // تحميل المزيد من البيانات (Pagination)
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await service.getApartments(
        filter: currentFilter.value,
        page: currentPage.value,
        limit: 10,
        refresh: false,
      );

      if (response['apartments'].isNotEmpty) {
        allApartments.addAll(response['apartments'] as List<Apartment>);
        filteredApartments.addAll(response['apartments'] as List<Apartment>);
      }

      hasMore.value = response['has_more'];
      totalPages.value = response['total_pages'];
    } catch (e) {
      errorMessage.value = "Failed to load more: ${e.toString()}";
      currentPage.value--;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadGovernorates() async {
    try {
      isLoading.value = true;
      governorates.value = await service.getGovernorates();
    } catch (e) {
      errorMessage.value = "Failed to load governorates";
    } finally {
      isLoading.value = false;
    }
  }

  void onGovernorateSelected(GovernorateModel gov) {
    selectedGovernorateId = gov.id;
    cities.value = gov.cities;
    selectedCityId = null;
  }

  // إعادة تعيين الفلتر
  void resetFilter() {
    currentFilter.value = FilterModel();
    searchQuery.value = '';
    loadAllApartments();
  }

  // دالة إنشاء شقة
  Future<bool> createApartment({
    required String title,
    required String description,
    required double rentValue,
    required int rooms,
    required double space,
    required String notes,
    required int governorateId,
    required int cityId,
    required String street,
    required String flatNumber,
    required int? longitude,
    required int? latitude,
    required List<XFile> houseImages,
  }) async {
    try {
      isCreating.value = true;
      createMessage.value = "";

      final response = await service.createApartment(
        title: title,
        description: description,
        rentValue: rentValue,
        rooms: rooms,
        space: space,
        notes: notes,
        governorateId: governorateId,
        cityId: cityId,
        street: street,
        flatNumber: flatNumber,
        longitude: longitude,
        latitude: latitude,
        houseImages: houseImages,
      );

      // تحديث البيانات بعد الإضافة
      await loadInitialData();

      createMessage.value = "Apartment added successfully";
      return true;
    } catch (e) {
      createMessage.value = "Failed to add apartment: $e";
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> toggleFavorite(int houseId) async {
    final bool isFav = favoriteIds.contains(houseId);

    if (isFav) {
      favoriteIds.remove(houseId);
      favoriteApartments.removeWhere((ap) => ap.id == houseId);
    } else {
      favoriteIds.add(houseId);
      final apartment = allApartments.firstWhere(
        (ap) => ap.id == houseId,
        orElse: () => Apartment(
          id: houseId,
          title: '',
          description: '',
          rentValue: 0,
          rooms: 0,
          space: 0,
          notes: '',
          cityId: 0,
          cityName: '',
          governorateId: 0,
          governorateName: '',
          street: '',
          flatNumber: '',
          longitude: null,
          latitude: null,
          houseImages: [],
        ),
      );
      favoriteApartments.add(apartment);
    }

    try {
      await service.toggleFavorite(houseId);
    } catch (e) {
      // rollback
      if (isFav) {
        favoriteIds.add(houseId);
        favoriteApartments.add(
          allApartments.firstWhere((ap) => ap.id == houseId),
        );
      } else {
        favoriteIds.remove(houseId);
        favoriteApartments.removeWhere((ap) => ap.id == houseId);
      }
    }
  }

  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      favoriteApartments.value = await service.getMyFavorites();

      // تحديث الـ favoriteIds عشان القلوب تتغير بالـ UI
      favoriteIds.value = favoriteApartments.map((e) => e.id).toSet();
    } catch (e) {
      errorMessage.value = "Failed to load favorites: $e";
    } finally {
      isLoading.value = false;
    }
  }

  // فحص إذا كان هناك فلتر أو بحث نشط
  bool get hasActiveFilter {
    return currentFilter.value.hasActiveFilters || searchQuery.value.isNotEmpty;
  }

  // الحصول على القائمة المناسبة للعرض
  List<Apartment> get displayApartments {
    if (hasActiveFilter) {
      return filteredApartments;
    }
    return allApartments;
  }
}
