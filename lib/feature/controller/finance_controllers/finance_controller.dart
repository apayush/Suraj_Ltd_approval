import 'package:get/get.dart';

class FinanceController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static FinanceController get instance => Get.find();

  RxBool isLoading = false.obs;

}
