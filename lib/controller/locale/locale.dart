import 'package:get/get.dart';

class MyLocale implements Translations{
  @override

  Map<String, Map<String, String>> get keys => {
    "ar" : {
      //onboarding_screen
      "Find Your Perfect Apartment" : "جد شقتك المثالية",
      "The easiest and fastest way to book apartments" : "اسهل واسرع طريقة لحجز الشقق",
      "Choose With Confidence" : "اختر بثقة",
      "Clear photos, full details, and transparent prices":"صور واضحة، تفاصيل كاملة، اسعار ملائمة",
      "Ready to Get Started?":"هل جاهز للبدء؟",
      "Start your journey with MR.Dar today":"إبدأ رحلتك مع MR.Dar اليوم",
      "Get Started":"فلنبدأ",
      "Skip":"تخطى",
      "Next":"التالي",

      //---------------------------------
      //add_apartment_page
      "Add Apartment":"أضف شقة",
      "General Information":"معلومات عامة",
      "Apartment Title":"عنوان الشقة",
      "Description":"الوصف",
      "Price / Month":"السعر / الشهر",
      "Rooms":"الغرف",
      "Space (m²)":"المساحة (م²)",
      "Location Details":"تفاصيل الموقع",
      "Select Governorate":"اختر محافظة",
      "Select City":"اختر مدينة",
      "Street Name":"اسم الشارع",
      "Flat Number":"رقم الشقة",
      "Longitude (opt)":"خط الطول (اختياري)",
      "Latitude (opt)":"خط العرض (اختياري)",
      "Apartment Gallery":"معرض الشقة",
      "Please select at least one clear image of the flat":"يرجى اختيار صورة واحدة واضحة على الأقل للشقة",
      "Error":"خطأ",
      "Please add at least one image":"يرجى إضافة صورة واحدة على الأقل",
      "Finish & Post":"إنهاء ونشر",
      "Continue":"أكمل",
      "Back":"رجوع",

      //---------------------------------
      //AllApartments
      "All Apartments":"كل الشقق",
      "Search":"بحث",
      "No apartments found":"لا يوجد شقق",

      //--------------------------------
      //apartment_details_page
      "Space":"المساحة",
      "m²":"²م",
      "Wi-Fi":"إنترنت",
      "Available":"متوفر",
      "Type":"نوع",
      "Apartment":"شقة",
      "About This House":"حول هذا المنزل",
      "Price":"السعر",
      "Reserve":"حجز",

      //--------------------------------
      //booking_confirm_page
      "Confirm BookingConfirm Booking":"تأكيد الحجز",
      "Location":"الموقع",
      "Booking Period":"فترة الحجز",
      "MMM dd, yyyy":"ش ي, س",
      "month(s)":"شهر(شهور)",
      "Payment":"الدفع",
      "Cash":"كاش",
      "Confirm Booking":"تأكيد الحجز",

      //----------------------------------------
      //booking_date_page
      "Select Booking Date":"اختر تاريخ الحجز",
      "Month":"شهر",
      "CHECK IN":"تسجيل دخول",
      "CHECK OUT":"تسجيل خروج",
      "Duration (Months)":"المدة (بالأشهر)",
      "Unavailable":"غير متوفر",
      "Selected period conflicts with existing bookings":"تتعارض الفترة المختارة مع الحجوزات الحالية",

      //-----------------------------------
      //edit_profile
      "Edit Profile":"تعديل الملف الشخصي",
      "Personal Information":"المعلومات الشخصية",
      "Security":"الحماية",
      "Validation Error":"خطأ في التحقق",
      "Please fix the errors in the form":"يرجى تصحيح الأخطاء في النموذج",
      "SAVE CHANGES":"حفظ التغييرات",
      "First Name":"الاسم الاول",
      "Last Name":"اسم العائلة",
      "Required field":"حقل مطلوب",
      "Phone Number":"رقم الهاتف",
      "Must be 10 digits":"يجب أن يكون مكونًا من 10 أرقام",
      "Date of Birth (Optional)":"تاريخ الميلاد (اختياري)",
      "Only fill to change password":"املأ هذا الخيار فقط لتغيير كلمة المرور",
      "New Password":"كلمة المرور الجديدة",
      "Confirm Password":"تأكيد كلمة المرور",
      "Please confirm your password":"يرجى تأكيد كلمة المرور الخاصة بك",
      "Passwords do not match":"كلمات المرور غير متطابقة",
      "Confirm Your Identity":"تأكيد هويتك",
      "Enter your current password to save changes:":"أدخل كلمة المرور الحالية لحفظ التغييرات:",
      "Current Password":"كلمة المرور الحالية",
      "This ensures your account security":"هذا يضمن أمان حسابك",
      "CANCEL":"إالغاء",
      "Password is required":"كلمة المرور مطلوبة",
      "Success":"نجح",
      "Your profile has been updated successfully":"تم تحديث ملفك الشخصي بنجاح",

      //----------------------------------------------------------------------------
      //favourite
      "No favorites yet":"لا توجد مفضلات حتى الآن",
      "Tap the heart icon on apartments to add them here":"انقر على أيقونة القلب الموجودة على الشقق لإضافتها هنا",
      "Browse Apartments":"تصفح الشقق",

      //---------------------------------
      //featurred_apartments_page
      "Featured Apartments":"شقق مميزة",

      //--------------------------------------
      //FilterPage
      "created_at":"تاريخ الإنشاء",
      "asc":"تصاعدي",
      "Newest":"الأحدث",
      "rent_value":"قيمة الإيجار",
      "Rent Asc":"زيادة الإيجار",
      "Rent Desc":"وصف الإيجار",
      "Apartment Filters":"فلاتر الشقق",
      "Clear All":"مسح الكل",
      "Rent Range (SYP)":"نطاق الإيجار (الليرة السورية)",
      "SYP":"الليرة السورية",
      "Rooms Number":"عدد الغرف",
      "Space Range (m²)":"نطاق المساحة (م²)",
      "Search by name or description":"ابحث بالاسم أو الوصف",
      "Sort By":"فرز حسب",
      "desc":"تنازلي",
      "Order Direction":"طلب توجيه",
      "Ascending":"تصاعدي",
      "Descending":"تنازلي",
      "Location Filter":"فلتر الموقع",
      "All Governorates":"كل المحافظات",
      "id":"رقم",
      "name":"اسم",
      "All Cities":"كل المدن",
      "Min:":"الحد الأدنى:",
      "Max:":"الحد الأعلى",
      "Reset All":"إعادة ضبط الكل",
      "Apply Filters":"تطبيق الفلاتر",

      //-----------------------------------------
      //home
      "My Apartments":"شققي",
      "My Rents":"حجوزاتي",
      "Favourite":"المفضلة",
      "My Account":"حسابي",
      "Refreshed":"آخر تحديث",
      "Favorites list updated":"تم تحديث قائمة المفضلة",
      "Home":"الصفحة الرئيسية",
      "Account":"الحساب",

      //----------------------------------------
      //homeContent
      "Active Filters":"الفلاتر المفعلة",
      "apartments found":"شقق تم العثور عليها",
      "See All":"عرض الكل",
      "Top Rated":"الأعلى تقييماً",
      "Filtered Results":"نتائج مُفلترة",
      "No apartments match your search":"لا توجد شقق مطابقة لبحثك",
      "Try adjusting your filters":"حاول ضبط الفلاتر الخاصة بك",
      "Adjust Filters":"ضبط الفلاتر",

      //----------------------------------------
      //login
      "Welcome Back":"مرحبًا بعودتك",
      "Phone required!":"يلزم وجود رقم الهاتف!",
      "Password required!":"كلمة المرور مطلوبة!",
      "Password":"كلمة المرور",
      "Min 8 characters!":"الحد الأدنى 8 أحرف!",
      "Log In":"تسجيل دخول",
      "Don’t have an account?":"ليس لديك حساب؟",
      "Sign Up":"اشتراك",

      //--------------------------------------
      //myAccount
      "No Profile Data":"لا توجد بيانات تعريفية",
      "Try Again":"حاول مجددا",
      "Showing cached data. Pull to refresh for latest updates":"عرض البيانات المخزنة مؤقتًا. اسحب للتحديث للاطلاع على آخر التحديثات.",
      "Refresh Profile":"تحديث الملف الشخصي",
      "owner":"مالك",
      "Update your personal information":"قم بتحديث معلوماتك الشخصية",
      "Settings":"الإعدادات",
      "App preferences and configurations":"تفضيلات التطبيق وإعداداته",

      //-------------------------------------
      //myApartments
      "Retry":"أعد المحاولة",
      "No apartments in":"لا توجد شقق في",
      "View Pending Apartments":"عرض الشقق المعلقة (قيد الانتظار)",

      //----------------------------------------
      //myRent
      "no reservations":"لا توجد حجوزات",
      "Edit":"تعديل",
      "Cancel Reservation":"إلغاء الحجز",
      "Are you sure you want to cancel this reservation?":"هل أنت متأكد من رغبتك في إلغاء هذا الحجز؟",
      "Yes, Cancel":"نعم، إلغاء",
      "No":"لا",

      //---------------------------------------
      //notifications_page
      "Notifications":"الإشعارات",
      "No notifications yet":"لم تصل أي إشعارات بعد",
      "accepted":"مقبول",

      //---------------------------
      //SearchSuggestionsPage
      "Search Apartments":"ابحث عن شقق",
      "Type at least 2 letters...":"اكتب حرفين على الأقل...",
      "No results found":"لم يتم العثور على نتائج",

      //-------------------------------
      //settings_screen
      "Logout":"تسجيل خروج",
      "Sign out from your account":"قم بتسجيل الخروج من حسابك",
      "Attention ! ":"انتباه !",
      "Are you sure you want to logout?":"هل أنت متأكد من رغبتك في تسجيل الخروج؟",
      "Confirm":"تأكيد",
      "Preferences":"التفضيلات",
      "Theme":"السمة",
      "Light / Dark mode":"الوضع الفاتح / الوضع الداكن",
      "Language":"اللغة",
      "Change app language":"تغيير لغة التطبيق",
      "Danger Zone":"منطقة الخطر",
      "Delete Account":"حذف الحساب",
      "Delete your account !":"احذف حسابك!",

      //-------------------------------------
      //signup
      "Join us & find your perfect home":"انضم إلينا واعثر على منزلك المثالي",
      "renter":"مستأجر",
      "First name is required!":"الاسم الأول مطلوب!",
      "Last name is required!":"اسم العائلة مطلوب!",
      "Date of Birth":"تاريخ الميلاد",
      "Date of Birth is required":"تاريخ الميلاد مطلوب",
      "Profile Image":"صورة الملف الشخصي",
      "Profile Image Selected":"تم اختيار صورة الملف الشخصي",
      "ID Image":"صور الهوية",
      "ID Image Selected":"تم اختيار صورة الهوية",
      "Confirm is required":"التأكيد مطلوب",
      "Not matching":"غير متطابق",

      //------------------------------------------
      //Splash
      "token":"توكين",
      "/home":"/الصفحة الرئيسية",
      "/onboarding":"/التأهيل",

      //--------------------------------
      //WelcomePage
      "Welcome to MR.Dar":"أهلاً بكم في MR.Dar",

      //----------------------------------
      //apartment_card
      "Removing from favorites...":"إزالة من المفضلة...",
      "Adding to favorites...":"تمت إضافته إلى المفضلة...",
      "Removed from favorites":"تمت إزالته من المفضلة",
      "Added to favorites":"تمت إضافته إلى المفضلة",
      "Failed to update favorites":"فشل تحديث المفضلة",
      "/ month":"/ شهر",
      "View":"عرض",


      "Login":"تسجيل دخول",
      "":"",
      "":"",
    } ,

  //=============================================================================================================================
  //=============================================================================================================================

    "en" : {
      //onboarding_screen
      "Find Your Perfect Apartment":"Find Your Perfect Apartment",
      "The easiest and fastest way to book apartments":"The easiest and fastest way to book apartments",
      "Choose With Confidence":"Choose With Confidence",
      "Clear photos, full details, and transparent prices":"Clear photos, full details, and transparent prices",
      "Ready to Get Started?":"Ready to Get Started?",
      "Start your journey with MR.Dar today":"Start your journey with MR.Dar today",
      "Get Started":"Get Started",
      "Skip":"Skip",
      "Next":"Next",

      //---------------------------------
      //add_apartment_page
      "Add Apartment":"Add Apartment",
      "General Information":"General Information",
      "Apartment Title":"Apartment Title",
      "Description":"Description",
      "Price / Month":"Price / Month",
      "Rooms":"Rooms",
      "Location Details":"Location Details",
      "Select Governorate":"Select Governorate",
      "Select City":"Select City",
      "Street Name":"Street Name",
      "Flat Number":"Flat Number",
      "Longitude (opt)":"Longitude (opt)",
      "Latitude (opt)":"Latitude (opt)",
      "Apartment Gallery":"Apartment Gallery",
      "Please select at least one clear image of the flat":"Please select at least one clear image of the flat",
      "Error":"Error",
      "Please add at least one image":"Please add at least one image",
      "Finish & Post":"Finish & Post",
      "Continue":"Continue",
      "Back":"Back",

      //---------------------------------
      //AllApartments
      "All Apartments":"All Apartments",
      "Search":"Search",
      "No apartments found":"No apartments found",

      //--------------------------------
      //apartment_details_page
      "Space":"Space",
      "m²":"m²",
      "Wi-Fi":"Wi-Fi",
      "Available":"Available",
      "Type":"Type",
      "Apartment":"Apartment",
      "About This House":"About This House",
      "Price":"Price",
      "Reserve":"Reserve",

      //------------------------------
      //booking_confirm_page
      "Confirm BookingConfirm Booking":"Confirm BookingConfirm Booking",
      "Location":"Location",
      "Booking Period":"Booking Period",
      "MMM dd, yyyy":"MMM dd, yyyy",
      "month(s)":"month(s)",
      "Payment":"Payment",
      "Cash":"Cash",
      "Confirm Booking":"Confirm Booking",

      //----------------------------------------
      //booking_date_page
      "Select Booking Date":"Select Booking Date",
      "Month":"Month",
      "CHECK IN":"CHECK IN",
      "CHECK OUT":"CHECK OUT",
      "Duration (Months)":"Duration (Months)",
      "Unavailable":"Unavailable",
      "Selected period conflicts with existing bookings":"Selected period conflicts with existing bookings",

      //-----------------------------------
      //edit_profile
      "Edit Profile":"Edit Profile",
      "Personal Information":"Personal Information",
      "Security":"Security",
      "Validation Error":"Validation Error",
      "Please fix the errors in the form":"Please fix the errors in the form",
      "SAVE CHANGES":"SAVE CHANGES",
      "First Name":"First Name",
      "Last Name":"Last Name",
      "Required field":"Required field",
      "Phone Number":"Phone Number",
      "Must be 10 digits":"Must be 10 digits",
      "Date of Birth (Optional)":"Date of Birth (Optional)",
      "Only fill to change password":"Only fill to change password",
      "New Password":"New Password",
      "Confirm Password":"Confirm Password",
      "Please confirm your password":"Please confirm your password",
      "Passwords do not match":"Passwords do not match",
      "Confirm Your Identity":"Confirm Your Identity",
      "Enter your current password to save changes:":"Enter your current password to save changes:",
      "Current Password":"Current Password",
      "This ensures your account security":"This ensures your account security",
      "CANCEL":"CANCEL",
      "Password is required":"Password is required",
      "Success":"Success",
      "Your profile has been updated successfully":"Your profile has been updated successfully",

      //----------------------------------------------------------------------------
      //favourite
      "No favorites yet":"No favorites yet",
      "Tap the heart icon on apartments to add them here":"Tap the heart icon on apartments to add them here",
      "Browse Apartments":"Browse Apartments",

      //---------------------------------
      //featurred_apartments_page
      "Featured Apartments":"Featured Apartments",

      //--------------------------------------
      //FilterPage
      "created_at":"created_at",
      "asc":"asc",
      "Newest":"Newest",
      "rent_value":"rent_value",
      "Rent Asc":"Rent Asc",
      "Rent Desc":"Rent Desc",
      "Apartment Filters":"Apartment Filters",
      "Clear All":"Clear All",
      "Rent Range (SYP)":"Rent Range (SYP)",
      "SYP":"SYP",
      "Rooms Number":"Rooms Number",
      "Space Range (m²)":"Space Range (m²)",
      "Search by name or description":"Search by name or description",
      "Sort By":"Sort By",
      "desc":"desc",
      "Order Direction":"Order Direction",
      "Ascending":"Ascending",
      "Descending":"Descending",
      "Location Filter":"Location Filter",
      "All Governorates":"All Governorates",
      "id":"id",
      "name":"name",
      "All Cities":"All Cities",
      "Min:":"Min:",
      "Max:":"Max:",
      "Reset All":"Reset All",
      "Apply Filters":"Apply Filters",

      //-----------------------------------------
      //home
      "My Apartments":"My Apartments",
      "My Rents":"My Rents",
      "Favourite":"Favourite",
      "My Account":"My Account",
      "Refreshed":"Refreshed",
      "Favorites list updated":"Favorites list updated",
      "Home":"Home",
      "Account":"Account",

      //--------------------------------------------------
      //homeContent
      "Active Filters":"Active Filters",
      "apartments found":"apartments found",
      "See All":"See All",
      "Top Rated":"Top Rated",
      "Filtered Results":"Filtered Results",
      "No apartments match your search":"No apartments match your search",
      "Try adjusting your filters":"Try adjusting your filters",
      "Adjust Filters":"Adjust Filters",

      //----------------------------------------
      //login
      "Welcome Back":"Welcome Back",
      "Phone required!":"Phone required!",
      "Password required!":"Password required!",
      "Password":"Password",
      "Min 8 characters!":"Min 8 characters!",
      "Log In":"Log In",
      "Don’t have an account?":"Don’t have an account?",
      "Sign Up":"Sign Up",

      //--------------------------------------
      //myAccount
      "No Profile Data":"No Profile Data",
      "Try Again":"Try Again",
      "Showing cached data. Pull to refresh for latest updates":"Showing cached data. Pull to refresh for latest updates",
      "Refresh Profile":"Refresh Profile",
      "owner":"owner",
      "Update your personal information":"Update your personal information",
      "Settings":"Settings",
      "App preferences and configurations":"App preferences and configurations",

      //-------------------------------------
      //myApartments
      "Retry":"Retry",
      "No apartments in":"No apartments in",
      "View Pending Apartments":"View Pending Apartments",
      "no reservations":"no reservations",
      "Edit":"Edit",
      "Cancel Reservation":"Cancel Reservation",
      "Are you sure you want to cancel this reservation?":"Are you sure you want to cancel this reservation?",
      "Yes, Cancel":"Yes, Cancel",
      "No":"No",

      //---------------------------------------
      //notifications_page
      "Notifications":"Notifications",
      "No notifications yet":"No notifications yet",
      "accepted":"accepted",

      //---------------------------
      //SearchSuggestionsPage
      "Search Apartments":"Search Apartments",
      "Type at least 2 letters...":"Type at least 2 letters...",
      "No results found":"No results found",

      //-------------------------------
      //settings_screen
      "Logout":"Logout",
      "Sign out from your account":"Sign out from your account",
      "Attention ! ":"Attention ! ",
      "Are you sure you want to logout?":"Are you sure you want to logout?",
      "Confirm":"Confirm",
      "Preferences":"Preferences",
      "Theme":"Theme",
      "Light / Dark mode":"Light / Dark mode",
      "Language":"Language",
      "Change app language":"Change app language",
      "Danger Zone":"Danger Zone",
      "Delete Account":"Delete Account",
      "Delete your account !":"Delete your account !",

      //-------------------------------------
      //signup
      "Join us & find your perfect home":"Join us & find your perfect home",
      "renter":"renter",
      "First name is required!":"First name is required!",
      "Last name is required!":"Last name is required!",
      "Date of Birth":"Date of Birth",
      "Date of Birth is required":"Date of Birth is required",
      "Profile Image":"Profile Image",
      "Profile Image Selected":"Profile Image Selected",
      "ID Image":"ID Image",
      "ID Image Selected":"ID Image Selected",
      "Confirm is required":"Confirm is required",
      "Not matching":"Not matching",

      //------------------------------------------
      //Splash
      "token":"token",
      "/home":"/home",
      "/onboarding":"/onboarding",

      //--------------------------------
      //WelcomePage
      "Welcome to MR.Dar":"Welcome to MR.Dar",

      //----------------------------------
      //apartment_card
      "Removing from favorites...":"Removing from favorites...",
      "Adding to favorites...":"Adding to favorites...",
      "Removed from favorites":"Removed from favorites",
      "Added to favorites":"Added to favorites",
      "Failed to update favorites":"Failed to update favorites",
      "/ month":"/ month",
      "View":"View",


      "Login":"Login",
      "":"",
      "":"",
    },
  };

}