import 'package:get/get.dart';
import '../service/review_service.dart';

class ReviewController extends GetxController {
  final ReviewService service;

  ReviewController({required this.service});

  RxBool canRate = false.obs;
  RxBool isLoading = false.obs;
  RxInt rating = 1.obs;

  Future<void> checkIfCanRate(int houseId) async {
    isLoading.value = true;
    canRate.value = await service.checkIfCanRate(houseId);
    isLoading.value = false;
  }

  Future<bool> submitReview(int houseId) async {
    return await service.submitReview(houseId: houseId, rating: rating.value);
  }
}
