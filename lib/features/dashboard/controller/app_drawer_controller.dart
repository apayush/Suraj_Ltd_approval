import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';
import 'package:suraj_approval/core/service/local_db.dart';

class AppDrawerController extends GetxController {
  SidebarXController sideBarXController = SidebarXController(
    selectedIndex: 0,
    extended: false,
  );

  void setSelectedMenuDrawer(MenuType menu) {
    final index =
        LocalDB.getUserModel()?.allowedMenus.indexWhere(
          (element) => element == menu,
        ) ??
        0;
    sideBarXController.selectIndex(index);
  }
}
