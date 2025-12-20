import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/apartment_model.dart';
import '../model/filter_model.dart';
import '../service/ApartmentService.dart';

class ApartmentController extends GetxController {
  final ApartmentService service;

  ApartmentController({required this.service});

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
    super.onInit();
    loadInitialData();
  }

  // تحميل البيانات الأولية
  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;

      await Future.wait([
        loadAllApartments(),
        loadFeaturedApartments(),
        loadTopRatedApartments(),
      ]);

    } catch (e) {
      errorMessage.value = "Failed to load initial data: ${e.toString()}";
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

  // تحميل الشقق المميزة
  Future<void> loadFeaturedApartments() async {
    try {
      featuredApartments.value = await service.getFeaturedApartments();
    } catch (e) {
      print("Error loading featured apartments: $e");
    }
  }

  // تحميل الشقق الأعلى تقييماً
  Future<void> loadTopRatedApartments() async {
    try {
      topRatedApartments.value = await service.getTopRatedApartments();
    } catch (e) {
      print("Error loading top rated apartments: $e");
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
    try {
      searchQuery.value = query;
      currentPage.value = 1;
      isLoading.value = true;

      final response = await service.searchApartments(query, page: 1);

      filteredApartments.value = response['apartments'] as List<Apartment>;
      currentPage.value = response['current_page'];
      totalPages.value = response['total_pages'];
      totalItems.value = response['total_items'];
      hasMore.value = response['has_more'];

    } catch (e) {
      errorMessage.value = "Failed to search: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

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
    required int? cityId,
    required String street,
    required int flatNumber,
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

  // فحص إذا كان هناك فلتر أو بحث نشط
  bool get hasActiveFilterOrSearch {
    return currentFilter.value.hasActiveFilters || searchQuery.value.isNotEmpty;
  }

  // الحصول على القائمة المناسبة للعرض
  List<Apartment> get displayApartments {
    if (hasActiveFilterOrSearch) {
      return filteredApartments;
    }
    return allApartments;
  }
}