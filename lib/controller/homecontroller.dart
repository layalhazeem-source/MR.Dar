import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    currentIndex.value = 0; // 🔥 إجباري
    super.onInit();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
