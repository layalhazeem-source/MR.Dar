import 'package:get/get.dart';
import '../model/filter_model.dart';

class FilterController extends GetxController {
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

  // الحصول على الفلتر الحالي
  FilterModel get activeFilter => currentFilter.value;

  // فحص إذا كان هناك فلتر فعال
  bool get hasActiveFilter => currentFilter.value.hasActiveFilters;
}