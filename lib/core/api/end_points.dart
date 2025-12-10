class EndPoint {
  static String baseUrl = "http://10.0.2.2:8000/api/";
  static String logIn = "login";
  static String signUp = "register";
  static const String getApartments = "houses"; // للحصول على القائمة
  static const String createApartment = "houses"; // لإنشاء شقة جديدة (نفس الرابط ولكن POST)
  static const String searchApartments = "houses/search";
  static const String filterApartments = "houses/filter";
}

class ApiKey {
  static String data = "data";
  static String errorMessage = "message";
  static String errorsList = "errors";
  static String phone = "phone";
  static String password = "password";

  /*
  static String email = "email";
  static String token = "token";
  static String id = "id";
   */
}
