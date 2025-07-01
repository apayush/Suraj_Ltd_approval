import 'package:get/get.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static DashboardController get instance => Get.find();

  RxBool isLoading = false.obs;

}
