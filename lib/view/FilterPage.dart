import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/FilterController.dart';
import '../model/filter_model.dart';

class FilterPage extends StatelessWidget {
  FilterPage({Key? key}) : super(key: key);

  // المتحكمات
  final Rx<RangeValues> rentRange = Rx(RangeValues(0, 5000));
  final Rx<RangeValues> roomsRange = Rx(RangeValues(1, 10));
  final Rx<RangeValues> spaceRange = Rx(RangeValues(0, 500));
  final TextEditingController searchController = TextEditingController();

  // خيارات الترتيب
  final RxString selectedSortBy = RxString('created_at');
  final RxString selectedSortDir = RxString('asc');

  // خيارات الترتيب المتاحة
  final Map<String, String> sortOptions = {
    'created_at': 'Newest',
    'rent_value': 'Rent (Low to High)',
    'rent_desc': 'Rent (High to Low)',
    'rooms': 'Number of Rooms',
    'space': 'Space (m²)',
  };

  // قائمة المحافظات مع الـ IDs
  final List<Map<String, dynamic>> governoratesList = [
    {'id': 1, 'name': 'Damascus'},
    {'id': 2, 'name': 'Rural Damascus'},
    {'id': 3, 'name': 'Aleppo'},
    {'id': 4, 'name': 'Homs'},
    {'id': 5, 'name': 'Hama'},
    {'id': 6, 'name': 'Idlib'},
    {'id': 7, 'name': 'Latakia'},
    {'id': 8, 'name': 'Tartus'},
    {'id': 9, 'name': 'Deir ez-Zor'},
    {'id': 10, 'name': 'Raqqa'},
    {'id': 11, 'name': 'Al-Hasakah'},
    {'id': 12, 'name': 'Daraa'},
    {'id': 13, 'name': 'Quneitra'},
    {'id': 14, 'name': 'As-Suwayda'},
  ];

  // قائمة المدن مع الـ IDs والمحافظات التابعة لها
  final List<Map<String, dynamic>> citiesList = [
    // Damascus cities (id: 1)
    {'id': 101, 'name': 'Al-Qadam', 'governorate_id': 1},
    {'id': 102, 'name': 'Sayyida Zainab', 'governorate_id': 1},
    {'id': 103, 'name': 'Al-Midan', 'governorate_id': 1},
    {'id': 104, 'name': 'Kafr Sousa', 'governorate_id': 1},
    {'id': 105, 'name': 'Jobar', 'governorate_id': 1},
    {'id': 106, 'name': 'Bab Touma', 'governorate_id': 1},
    {'id': 107, 'name': 'Baramkeh', 'governorate_id': 1},
    {'id': 108, 'name': 'Mezzeh', 'governorate_id': 1},
    {'id': 109, 'name': 'Rukn al-Din', 'governorate_id': 1},
    {'id': 110, 'name': 'Qanawat', 'governorate_id': 1},
    {'id': 111, 'name': 'Tadamun', 'governorate_id': 1},
    {'id': 112, 'name': 'Shaghour', 'governorate_id': 1},
    {'id': 113, 'name': 'Khan al-Sabil', 'governorate_id': 1},
    {'id': 114, 'name': 'Al-Mazraa', 'governorate_id': 1},
    {'id': 115, 'name': 'Other', 'governorate_id': 1},

    // Rural Damascus cities (id: 2)
    {'id': 201, 'name': 'Douma', 'governorate_id': 2},
    {'id': 202, 'name': 'Al-Tall', 'governorate_id': 2},
    {'id': 203, 'name': 'Al-Qutayfah', 'governorate_id': 2},
    {'id': 204, 'name': 'An-Nabek', 'governorate_id': 2},
    {'id': 205, 'name': 'Al-Malihah', 'governorate_id': 2},
    {'id': 206, 'name': 'Other', 'governorate_id': 2},

    // Aleppo cities (id: 3)
    {'id': 301, 'name': 'Manbij', 'governorate_id': 3},
    {'id': 302, 'name': 'Afrin', 'governorate_id': 3},
    {'id': 303, 'name': 'Azaz', 'governorate_id': 3},
    {'id': 304, 'name': 'Al-Bab', 'governorate_id': 3},
    {'id': 305, 'name': 'Other', 'governorate_id': 3},

    // Homs cities (id: 4)
    {'id': 401, 'name': 'Tadmur', 'governorate_id': 4},
    {'id': 402, 'name': 'Al-Qusayr', 'governorate_id': 4},
    {'id': 403, 'name': 'Al-Rastan', 'governorate_id': 4},
    {'id': 404, 'name': 'Talbiseh', 'governorate_id': 4},
    {'id': 405, 'name': 'Other', 'governorate_id': 4},

    // Hama cities (id: 5)
    {'id': 501, 'name': 'Mahardah', 'governorate_id': 5},
    {'id': 502, 'name': 'Salamiyah', 'governorate_id': 5},
    {'id': 503, 'name': 'Al-Suqaylabiyah', 'governorate_id': 5},
    {'id': 504, 'name': 'Masyaf', 'governorate_id': 5},
    {'id': 505, 'name': 'Other', 'governorate_id': 5},

    // Idlib cities (id: 6)
    {'id': 601, 'name': 'Jisr al-Shughur', 'governorate_id': 6},
    {'id': 602, 'name': 'Ariha', 'governorate_id': 6},
    {'id': 603, 'name': 'Saraqib', 'governorate_id': 6},
    {'id': 604, 'name': 'Maarrat al-Nu\'man', 'governorate_id': 6},
    {'id': 605, 'name': 'Other', 'governorate_id': 6},

    // Latakia cities (id: 7)
    {'id': 701, 'name': 'Jableh', 'governorate_id': 7},
    {'id': 702, 'name': 'Qardaha', 'governorate_id': 7},
    {'id': 703, 'name': 'Safita', 'governorate_id': 7},
    {'id': 704, 'name': 'Baniyas', 'governorate_id': 7},
    {'id': 705, 'name': 'Other', 'governorate_id': 7},

    // Tartus cities (id: 8)
    {'id': 801, 'name': 'Baniyas', 'governorate_id': 8},
    {'id': 802, 'name': 'Duraykish', 'governorate_id': 8},
    {'id': 803, 'name': 'Al-Hamidiyah', 'governorate_id': 8},
    {'id': 804, 'name': 'Safita', 'governorate_id': 8},
    {'id': 805, 'name': 'Other', 'governorate_id': 8},

    // Deir ez-Zor cities (id: 9)
    {'id': 901, 'name': 'Mayadin', 'governorate_id': 9},
    {'id': 902, 'name': 'Al-Busayrah', 'governorate_id': 9},
    {'id': 903, 'name': 'Al-Quriyah', 'governorate_id': 9},
    {'id': 904, 'name': 'Abu Kamal', 'governorate_id': 9},
    {'id': 905, 'name': 'Other', 'governorate_id': 9},

    // Raqqa cities (id: 10)
    {'id': 1001, 'name': 'Al-Tabqah', 'governorate_id': 10},
    {'id': 1002, 'name': 'Tal Abyad', 'governorate_id': 10},
    {'id': 1003, 'name': 'Ain Issa', 'governorate_id': 10},
    {'id': 1004, 'name': 'Sukhnah', 'governorate_id': 10},
    {'id': 1005, 'name': 'Other', 'governorate_id': 10},

    // Al-Hasakah cities (id: 11)
    {'id': 1101, 'name': 'Qamishli', 'governorate_id': 11},
    {'id': 1102, 'name': 'Al-Malikiyah', 'governorate_id': 11},
    {'id': 1103, 'name': 'Ras al-Ain', 'governorate_id': 11},
    {'id': 1104, 'name': 'Amuda', 'governorate_id': 11},
    {'id': 1105, 'name': 'Other', 'governorate_id': 11},

    // Daraa cities (id: 12)
    {'id': 1201, 'name': 'Jasim', 'governorate_id': 12},
    {'id': 1202, 'name': 'Izra', 'governorate_id': 12},
    {'id': 1203, 'name': 'Al-Sanamayn', 'governorate_id': 12},
    {'id': 1204, 'name': 'Muzayrib', 'governorate_id': 12},
    {'id': 1205, 'name': 'Other', 'governorate_id': 12},

    // Quneitra cities (id: 13)
    {'id': 1301, 'name': 'Khan Arnabah', 'governorate_id': 13},
    {'id': 1302, 'name': 'Fiq', 'governorate_id': 13},
    {'id': 1303, 'name': 'Buq\'ata', 'governorate_id': 13},
    {'id': 1304, 'name': 'Beit Jinn', 'governorate_id': 13},
    {'id': 1305, 'name': 'Other', 'governorate_id': 13},

    // As-Suwayda cities (id: 14)
    {'id': 1401, 'name': 'Salkhad', 'governorate_id': 14},
    {'id': 1402, 'name': 'Shahba', 'governorate_id': 14},
    {'id': 1403, 'name': 'Al-Mazraa', 'governorate_id': 14},
    {'id': 1404, 'name': 'Hauran towns', 'governorate_id': 14},
    {'id': 1405, 'name': 'Other', 'governorate_id': 14},
  ];

  // متغيرات للمحافظة والمدينة المختارة (بالـ IDs)
  final RxInt selectedGovernorateId = RxInt(0);
  final RxInt selectedCityId = RxInt(0);

  // قائمة المدن للمحافظة المختارة
  final RxList<Map<String, dynamic>> filteredCities = RxList([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apartment Filters"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text("Clear All"),
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
                      title: "Rent Range (SYP)",
                      range: rentRange,
                      min: 0,
                      max: 5000,
                      divisions: 50,
                      unit: 'SYP',
                    ),
                    const SizedBox(height: 20),

                    // نطاق الغرف
                    _buildRangeSection(
                      context,
                      title: "Rooms Range",
                      range: roomsRange,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      unit: 'rooms',
                    ),
                    const SizedBox(height: 20),

                    // نطاق المساحة
                    _buildRangeSection(
                      context,
                      title: "Space Range (m²)",
                      range: spaceRange,
                      min: 0,
                      max: 500,
                      divisions: 25,
                      unit: 'm²',
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
          "Search",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: "Search by name or description",
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
          "Sort By",
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
                    selectedSortDir.value = 'asc';
                  } else if (value == 'rent_desc') {
                    selectedSortDir.value = 'desc';
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
          final shouldShowSortDir = selectedSortBy.value == 'rooms' ||
              selectedSortBy.value == 'space' ||
              selectedSortBy.value == 'created_at';

          if (!shouldShowSortDir) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Order Direction",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Ascending'),
                      value: 'asc',
                      groupValue: selectedSortDir.value,
                      onChanged: (value) => selectedSortDir.value = value!,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Descending'),
                      value: 'desc',
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
          "Location Filter",
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
              decoration: const InputDecoration(
                labelText: "Select Governorate",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              items: [
                const DropdownMenuItem<int>(
                  value: 0,
                  child: Text("All Governorates"),
                ),
                ...governoratesList.map<DropdownMenuItem<int>>((gov) {
                  return DropdownMenuItem<int>(
                    value: gov['id'],
                    child: Text(gov['name']),
                  );
                }).toList(),
              ],
              onChanged: (int? value) {
                selectedGovernorateId.value = value ?? 0;
                selectedCityId.value = 0;
                _filterCitiesByGovernorate(value ?? 0);
              },
              isExpanded: true,
            )),
            const SizedBox(height: 15),

            // Dropdown المدينة
            Obx(() => DropdownButtonFormField<int>(
              value: selectedCityId.value == 0 ? null : selectedCityId.value,
              decoration: const InputDecoration(
                labelText: "Select City",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              items: [
                const DropdownMenuItem<int>(
                  value: 0,
                  child: Text("All Cities"),
                ),
                ...filteredCities.map<DropdownMenuItem<int>>((city) {
                  return DropdownMenuItem<int>(
                    value: city['id'],
                    child: Text(city['name']),
                  );
                }).toList(),
              ],
              onChanged: (int? value) => selectedCityId.value = value ?? 0,
              isExpanded: true,
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
                    label: Text('Min: ${range.value.start.round()} $unit'),
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  Chip(
                    label: Text('Max: ${range.value.end.round()} $unit'),
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
            child: const Text(
              "Reset All",
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
            child: const Text(
              "Apply Filters",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // دالة لتصفية المدن حسب المحافظة
  void _filterCitiesByGovernorate(int governorateId) {
    if (governorateId == 0) {
      filteredCities.value = [];
    } else {
      filteredCities.value = citiesList
          .where((city) => city['governorate_id'] == governorateId)
          .toList();
    }
  }

  // دالة إعادة تعيين جميع الفلاتر
  void _resetFilters() {
    rentRange.value = const RangeValues(0, 5000);
    roomsRange.value = const RangeValues(1, 10);
    spaceRange.value = const RangeValues(0, 500);
    searchController.clear();
    selectedGovernorateId.value = 0;
    selectedCityId.value = 0;
    selectedSortBy.value = 'created_at';
    selectedSortDir.value = 'asc';
    filteredCities.value = [];
  }

  // دالة تطبيق الفلاتر
  void _applyFilters() {
    // تحويل ترتيب الإيجار إذا كان 'rent_desc' مختاراً
    String finalSortBy = selectedSortBy.value;
    if (selectedSortBy.value == 'rent_desc') {
      finalSortBy = 'rent_value';
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
      minRent: rentRange.value.start.round().toInt(),
      maxRent: rentRange.value.end.round().toInt(),
      minRooms: roomsRange.value.start.round().toInt(),
      maxRooms: roomsRange.value.end.round().toInt(),
      minSpace: spaceRange.value.start.round().toInt(),
      maxSpace: spaceRange.value.end.round().toInt(),
      sortBy: finalSortBy,
      sortDir: selectedSortDir.value,
    );

    Get.back(result: filter);
  }
}