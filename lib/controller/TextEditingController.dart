import 'package:get/get.dart';

import '../model/apartment_model.dart';

class ApartmentController extends GetxController {
  var searchResults = <Apartment>[].obs;
  var isSearching = false.obs;

  void searchApartments(String query, dynamic api) async {
    if (query.length < 2) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final response = await api.dio.get('/apartments', queryParameters: {
        'search': query,
      });

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        searchResults.value = data.map((e) => Apartment.fromJson(e)).toList();
      }
    } catch (e) {
      searchResults.clear();
      print("Search error: $e");
    } finally {
      isSearching.value = false;
    }
  }
}
