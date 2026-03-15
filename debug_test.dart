import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/extentions/menu_extension.dart';

void main() {
  print('From Enum directly: ' + SubMenuType.fromKey('Hourly Report').toString());
  print('From Extension: ' + SubMenuTypeExtension.fromKey('Hourly Report').toString());
  print('From Enum directly (Production): ' + MenuType.fromKey('Production').toString());
}
