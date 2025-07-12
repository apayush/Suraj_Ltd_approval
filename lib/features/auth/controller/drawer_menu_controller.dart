// import 'package:get/get.dart';
// import 'package:suraj_approval/core/constants/app_enum.dart';
//
// import '../../../core/models/user_model.dart';
// import '../../../core/service/local_db.dart';
//
// class DrawerMenuController extends GetxController {
//   final RxList<UserDetails> userMenus = <UserDetails>[].obs;
//
//   void loadMenusFromLocalDB() {
//     print('🟢 Loading menus from LocalDB...');
//     final user = LocalDB.getUserModel();
//     if (user != null) {
//       userMenus.assignAll(user.userDetails);
//       print('🟢 Loaded ${userMenus.length} menus');
//     } else {
//       print('🔴 No user data found');
//     }
//   }
//
//   List<MenuType?> getMainMenus() {
//     print('🟢 Current userMenus: ${userMenus.length} items');
//     userMenus.forEach((menu) => print('🟢 Menu: ${menu.mainMenu?.key}'));
//
//     final menus = userMenus.map((e) => e.mainMenu).toSet().toList();
//     print('🟢 Unique main menus: $menus');
//     return menus;
//   }
//
//   List<SubMenuType?> getSubMenus(String mainMenu) {
//     return userMenus
//         .where((e) => e.mainMenu == mainMenu)
//         .map((e) => e.subMenu)
//         .toList();
//   }
//
//   Map<MenuType, List<SubMenuType>> getGroupedMenus() {
//     final groupedMenus = <MenuType, List<SubMenuType>>{};
//
//     for (final detail in userMenus) {
//       if (detail.mainMenu != null && detail.subMenu != null) {
//         groupedMenus.putIfAbsent(
//           detail.mainMenu!,
//               () => [],
//         ).add(detail.subMenu!);
//       }
//     }
//
//     return groupedMenus;
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadMenusFromLocalDB();
//   }
// }
