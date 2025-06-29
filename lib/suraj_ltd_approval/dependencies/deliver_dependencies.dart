import 'package:get/get.dart';
import 'package:shared_component/controllers/deliver_drawer_controller.dart';

class AppDependencies{

  static void init() {
    Get.put<DeliverDrawerController>(DeliverDrawerController(),permanent: true);
  }
}