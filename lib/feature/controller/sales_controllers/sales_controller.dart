import 'package:get/get.dart';

class SalesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static SalesController get instance => Get.find();

  RxBool isLoading = false.obs;

}
