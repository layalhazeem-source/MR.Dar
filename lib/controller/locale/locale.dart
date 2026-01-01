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
      "Last Name":"الاسم الاخير",
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
      "":"",
      "":"",
    } ,


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
      "":"",
      "":"",
    },
  };

}