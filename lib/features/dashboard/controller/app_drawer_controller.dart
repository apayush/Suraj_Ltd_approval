import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

class AppDrawerController extends GetxController {
  SidebarXController sideBarXController = SidebarXController(selectedIndex: 0, extended: false);

  @override
  void onInit() {
    super.onInit();
  }

  // Resetting the selectedItem when the controller is disposed
  @override
  void onClose() {
    super.onClose();
  }
}
