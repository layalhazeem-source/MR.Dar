import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ApartmentController.dart';
import '../controller/FilterController.dart';
import '../model/filter_model.dart';

class FilterPage extends StatelessWidget {
  FilterPage({Key? key}) : super(key: key);

  final ApartmentController controller = Get.find<ApartmentController>();

  // المتحكمات
  final Rx<RangeValues> rentRange = Rx(RangeValues(0, 5000));
  final Rx<RangeValues> roomsRange = Rx(RangeValues(1, 10));
  final Rx<RangeValues> spaceRange = Rx(RangeValues(0, 500));
  final TextEditingController searchController = TextEditingController();

  // خيارات الترتيب
  final RxString selectedSortBy = RxString('created_at'.tr);
  final RxString selectedSortDir = RxString('asc'.tr);
  final RxList<Map<String, dynamic>> sortOptionsFromApi = RxList([]);


  // متغيرات للمحافظة والمدينة المختارة (بالـ IDs)
  final RxInt selectedGovernorateId = RxInt(0);
  final RxInt selectedCityId = RxInt(0);

  // قائمة المدن للمحافظة المختارة
  final RxList<Map<String, dynamic>> filteredCities = RxList([]);

  final Map<String, String> sortOptions = {
    'created_at'.tr: 'Newest'.tr,
    'Rooms'.tr: 'Rooms'.tr,
    'Space'.tr: 'Space'.tr,
    'rent_value'.tr: 'Rent Asc'.tr,
    'Rent Desc'.tr: 'Rent Desc'.tr,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Apartment Filters".tr),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child:  Text("Clear All".tr),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // البحث
                    _buildSearchSection(context),
                    const Divider(height: 30),

                    // الترتيب
                    _buildSortSection(context),
                    const Divider(height: 30),

                    // الموقع
                    _buildLocationSection(context),
                    const Divider(height: 30),

                    // نطاق الإيجار
                    _buildRangeSection(
                      context,
                      title: "Rent Range (SYP)".tr,
                      range: rentRange,
                      min: 0,
                      max: 5000,
                      divisions: 50,
                      unit: 'SYP'.tr,
                    ),
                    const SizedBox(height: 20),

                    // نطاق الغرف
                    _buildRangeSection(
                      context,
                      title: "Rooms Number".tr,
                      range: roomsRange,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      unit: 'Rooms'.tr,
                    ),
                    const SizedBox(height: 20),

                    // نطاق المساحة
                    _buildRangeSection(
                      context,
                      title: "Space Range (m²)".tr,
                      range: spaceRange,
                      min: 0,
                      max: 500,
                      divisions: 25,
                      unit: 'm²'.tr,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // أزرار التطبيق
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  // قسم البحث
  Widget _buildSearchSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search".tr,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: "Search by name or description".tr,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => searchController.clear(),
            )
                : null,
          ),
          onChanged: (value) {},
        ),
      ],
    );
  }

  // قسم الترتيب
  Widget _buildSortSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sort By".tr,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => Column(
          children: sortOptions.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: selectedSortBy.value,
              onChanged: (String? value) {
                if (value != null) {
                  selectedSortBy.value = value;
                  // إذا كان الخيار متعلق بالإيجار، نضبط الاتجاه المناسب

                  if (value == 'rent_value') {
                    selectedSortDir.value = 'asc'.tr;
                  } else if (value == 'rent_desc') {
                    selectedSortDir.value = 'desc'.tr;
                  }
                }
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }).toList(),
        )),

        // خيار الاتجاه (لخيارات محددة فقط)
        Obx(() {
          final shouldShowSortDir = selectedSortBy.value == 'Rooms'.tr ||
              selectedSortBy.value == 'Space'.tr ||
              selectedSortBy.value == 'created_at'.tr;

          if (!shouldShowSortDir) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Order Direction".tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title:  Text('Ascending'.tr),
                      value: 'asc'.tr,
                      groupValue: selectedSortDir.value,
                      onChanged: (value) => selectedSortDir.value = value!,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title:  Text('Descending'.tr),
                      value: 'desc'.tr,
                      groupValue: selectedSortDir.value,
                      onChanged: (value) => selectedSortDir.value = value!,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }

  // قسم الموقع
  Widget _buildLocationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location Filter".tr,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown المحافظة
            Obx(() => DropdownButtonFormField<int>(
              value: selectedGovernorateId.value == 0 ? null : selectedGovernorateId.value,
              decoration:  InputDecoration(
                labelText: "Select Governorate".tr,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              items: [
                 DropdownMenuItem<int>(
                  value: 0,
                  child: Text("All Governorates".tr),
                ),
                ...controller.governorates.map<DropdownMenuItem<int>>((gov) {
                  return DropdownMenuItem<int>(
                    value: gov.id,
                    child: Text(gov.name),
                  );
                }).toList(),
              ],
    onChanged: (int? value) {
    selectedGovernorateId.value = value ?? 0;
    selectedCityId.value = 0;

    if (value == null || value == 0) {
    filteredCities.clear();
    return;
    }

    final gov = controller.governorates
        .firstWhere((g) => g.id == value);

    filteredCities.value = gov.cities
        .map((c) => {'id'.tr: c.id, 'name'.tr: c.name})
        .toList();

              },
            )),
            const SizedBox(height: 15),

            // Dropdown المدينة
            Obx(() => DropdownButtonFormField<int>(
              value: selectedCityId.value == 0 ? null : selectedCityId.value,
              decoration:  InputDecoration(
                labelText: "Select City".tr,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              items: [
                 DropdownMenuItem<int>(
                  value: 0,
                  child: Text("All Cities".tr),
                ),
                ...filteredCities.map<DropdownMenuItem<int>>((city) {
                  return DropdownMenuItem<int>(
                    value: city['id'.tr],
                    child: Text(city['name'.tr]),
                  );
                }).toList(),
              ],
              onChanged: (int? value) => selectedCityId.value = value ?? 0,
            )),
          ],
        ),
      ],
    );
  }

  // قسم النطاقات (الإيجار، الغرف، المساحة)
  Widget _buildRangeSection(
      BuildContext context, {
        required String title,
        required Rx<RangeValues> range,
        required double min,
        required double max,
        required int divisions,
        required String unit,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => Column(
          children: [
            RangeSlider(
              values: range.value,
              min: min,
              max: max,
              divisions: divisions,
              labels: RangeLabels(
                '${range.value.start.round()} $unit',
                '${range.value.end.round()} $unit',
              ),
              onChanged: (RangeValues values) => range.value = values,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text('Min: ${range.value.start.round()} $unit'.tr),
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  Chip(
                    label: Text('Max: ${range.value.end.round()} $unit'.tr),
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }

  // أزرار التطبيق والريست
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _resetFilters,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(55),
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            child:  Text(
              "Reset All".tr,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(55),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child:  Text(
              "Apply Filters".tr,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }


  // دالة إعادة تعيين جميع الفلاتر
  void _resetFilters() {
    rentRange.value = const RangeValues(0, 5000);
    roomsRange.value = const RangeValues(1, 10);
    spaceRange.value = const RangeValues(0, 500);
    searchController.clear();
    selectedGovernorateId.value = 0;
    selectedCityId.value = 0;
    selectedSortBy.value = 'created_at'.tr;
    selectedSortDir.value = 'asc'.tr;
    filteredCities.value = [];

    controller.resetFilter(); // إعادة تحميل كل البيانات بدون فلتر
  }


  // دالة تطبيق الفلاتر
  void _applyFilters() {
    String finalSortBy = selectedSortBy.value;
    if (selectedSortBy.value == 'rent_desc'.tr) {
      finalSortBy = 'rent_value'.tr;
    }

    final FilterModel filter = FilterModel(
      search: searchController.text.trim().isEmpty
          ? null
          : searchController.text.trim(),
      governorateId: selectedGovernorateId.value == 0
          ? null
          : selectedGovernorateId.value,
      cityId: selectedCityId.value == 0
          ? null
          : selectedCityId.value,
      minRent: rentRange.value.start.round(),
      maxRent: rentRange.value.end.round(),
      minRooms: roomsRange.value.start.round(),
      maxRooms: roomsRange.value.end.round(),
      minSpace: spaceRange.value.start.round(),
      maxSpace: spaceRange.value.end.round(),
      sortBy: finalSortBy,
      sortDir: selectedSortDir.value,
    );

    controller.applyFilter(filter); // جلب البيانات من الباك
    Get.back(); // إغلاق صفحة الفلاتر
  }

}