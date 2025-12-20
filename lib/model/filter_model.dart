class FilterModel {
  String? search;
  int? governorateId;    // نستخدم ID فقط
  int? cityId;           // نستخدم ID فقط
  int? minRent;
  int? maxRent;
  int? minRooms;
  int? maxRooms;
  int? minSpace;
  int? maxSpace;
  String? sortBy;
  String? sortDir;

  FilterModel({
    this.search,
    this.governorateId,
    this.cityId,
    this.minRent,
    this.maxRent,
    this.minRooms,
    this.maxRooms,
    this.minSpace,
    this.maxSpace,
    this.sortBy = 'created_at', // قيمة افتراضية
    this.sortDir = 'asc',        // قيمة افتراضية
  });

  // تنسيق JSON أو Map
  factory FilterModel.fromMap(Map<String, dynamic> map) {
    return FilterModel(
      search: map['search'] as String?,
      governorateId: map['governorate_id'] as int?,
      cityId: map['city_id'] as int?,
      minRent: map['min_rent'] as int? ?? map['min_price'] as int?,
      maxRent: map['max_rent'] as int? ?? map['max_price'] as int?,
      minRooms: map['min_rooms'] as int?,
      maxRooms: map['max_rooms'] as int?,
      minSpace: map['min_space'] as int?,
      maxSpace: map['max_space'] as int?,
      sortBy: map['sort_by'] as String? ?? 'created_at',
      sortDir: map['sort_dir'] as String? ?? 'asc',
    );
  }

  // تحويل إلى query parameters
  Map<String, dynamic> toQuery() {
    final Map<String, dynamic> q = {};

    if (cityId != null) q['city_id'] = cityId;
    if (governorateId != null) q['governorate_id'] = governorateId;
    if (minRent != null) q['min_rent'] = minRent;
    if (maxRent != null) q['max_rent'] = maxRent;
    if (minRooms != null) q['min_rooms'] = minRooms;
    if (maxRooms != null) q['max_rooms'] = maxRooms;
    if (minSpace != null) q['min_space'] = minSpace;
    if (maxSpace != null) q['max_space'] = maxSpace;
    if (search != null && search!.isNotEmpty) q['search'] = search;
    if (sortBy != null && sortBy != 'none') q['sort_by'] = sortBy;
    if (sortDir != null && sortBy != 'none') q['sort_dir'] = sortDir;

    return q;
  }

  // نسخ FilterModel مع تحديثات
  FilterModel copyWith({
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
    return FilterModel(
      search: search ?? this.search,
      governorateId: governorateId ?? this.governorateId,
      cityId: cityId ?? this.cityId,
      minRent: minRent ?? this.minRent,
      maxRent: maxRent ?? this.maxRent,
      minRooms: minRooms ?? this.minRooms,
      maxRooms: maxRooms ?? this.maxRooms,
      minSpace: minSpace ?? this.minSpace,
      maxSpace: maxSpace ?? this.maxSpace,
      sortBy: sortBy ?? this.sortBy,
      sortDir: sortDir ?? this.sortDir,
    );
  }

  // فحص إذا كان هناك فلتر مفعل
  bool get hasActiveFilters {
    return search?.isNotEmpty == true ||
        governorateId != null ||
        cityId != null ||
        minRent != null ||
        maxRent != null ||
        minRooms != null ||
        maxRooms != null ||
        minSpace != null ||
        maxSpace != null ||
        (sortBy != null && sortBy != 'created_at') ||
        (sortDir != null && sortDir != 'asc');
  }

  // إعادة ضبط كل الفلاتر
  FilterModel clear() {
    return FilterModel();
  }
}