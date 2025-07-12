import '../constants/app_enum.dart';
import '../models/user_model.dart';

extension MenuTypeExtension on MenuType {
  String get key => toString().split('.').last;

  static MenuType? fromKey(String? key) {
    if (key == null) return null;
    return MenuType.values.firstWhere(
          (e) => e.key.toLowerCase() == key.toLowerCase(),
      orElse: () => MenuType.finance, // fallback if needed
    );
  }
}

extension SubMenuTypeExtension on SubMenuType {
  String get key => toString().split('.').last;

  static SubMenuType? fromKey(String? key) {
    if (key == null) return null;
    return SubMenuType.values.firstWhere(
          (e) => e.key.toLowerCase() == key.toLowerCase(),
      orElse: () => SubMenuType.bankPayment,
    );
  }
}

extension UserPermissionExtensions on UserModel {
  /// List of all allowed main menus (no duplicates)
  List<MenuType> get allowedMenus => userDetails
      .map((e) => e.mainMenu)
      .whereType<MenuType>()
      .toSet()
      .toList();

  /// Get submenus for a given main menu
  List<SubMenuType> getSubMenusFor(MenuType menu) => userDetails
      .where((e) => e.mainMenu == menu)
      .map((e) => e.subMenu)
      .whereType<SubMenuType>()
      .toList();

  bool hasMenu(MenuType menu) => allowedMenus.contains(menu);

  bool hasSubMenu(MenuType menu, SubMenuType submenu) =>
      userDetails.any((e) => e.mainMenu == menu && e.subMenu == submenu);
}
