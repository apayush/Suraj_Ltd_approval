import 'package:get/get.dart';
import '../controllers/app_drawer_controller.dart';
import '../controllers/dashboard_controllers/dashboard_controller.dart';
import '../controllers/sidebarx_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SidebarController>(() => SidebarController());
    Get.lazyPut<AppDrawerController>(() => AppDrawerController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
