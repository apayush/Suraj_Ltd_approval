import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

class AppDrawerController extends GetxController {
  SidebarXController sideBarXController = SidebarXController(
    selectedIndex: 0,
    extended: false,
  );

  void setIndex(int index) {
    sideBarXController.selectIndex(index);
  }
}
