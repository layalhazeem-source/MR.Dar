import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt counter = 0.obs;
  void increament() {
    counter++;
  }

  void decreament() {
    counter--;
  }
}
