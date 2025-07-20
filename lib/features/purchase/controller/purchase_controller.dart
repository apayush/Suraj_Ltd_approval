import 'package:get/get.dart';

class PurchaseController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static PurchaseController get instance => Get.find();

  RxBool isLoading = false.obs;
}
