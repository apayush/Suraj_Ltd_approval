import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get.dart';

class SalesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static SalesController get instance => Get.find();

  RxBool isLoading = false.obs;

}
