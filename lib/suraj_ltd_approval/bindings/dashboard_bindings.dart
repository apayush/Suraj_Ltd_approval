import 'package:get/get.dart';
import '../controllers/dashboard_controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<FilterController>(() => FilterController());
    Get.lazyPut<DashboardController>(() => DashboardController());

  }
}
