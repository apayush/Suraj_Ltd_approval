import 'package:get/get.dart';

class ProductionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ProductionController get instance => Get.find();

  RxBool isLoading = false.obs;

}
