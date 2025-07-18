import 'package:collection/collection.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';

class UserModel {
  final String mUser;
  final String fcmid;
  final List<UserDetails> userDetails;

  UserModel({
    required this.mUser,
    required this.fcmid,
    required this.userDetails,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {

    final userDetails = (json['userDetails'] ?? json['UserDetails']) as List?;

    return UserModel(
      mUser: json['mUser'] ?? json['MUser'],
      fcmid: json['fcmid'] ?? json['FCMId'],
      userDetails: userDetails?.map((e) {
        return UserDetails.fromJson(e);
      }).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mUser': mUser,
      'fcmid': fcmid,
      'userDetails': userDetails.map((e) => e.toJson()).toList(),
    };
  }

  UserDetails? getDetailFor(MenuType menu, SubMenuType submenu) {
    return userDetails.firstWhereOrNull(
          (e) => e.mainMenu == menu && e.subMenu == submenu,
    );
  }
}

class UserDetails {
  final String branch;
  final String type;
  final String ids;
  final String userLevel;
  final MenuType? mainMenu;
  final SubMenuType? subMenu;

  UserDetails({
    required this.branch,
    required this.type,
    required this.ids,
    required this.userLevel,
    required this.mainMenu,
    required this.subMenu,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    final mainMenuStr = json['MainMenu'] ?? json['mainMenu'] ?? json['mainmenu'];
    final subMenuStr = json['SubMenu'] ?? json['subMenu'] ?? json['submenu'];

    return UserDetails(
      branch: json['Branch'] ?? json['branch'],
      type: json['Type'] ?? json['type'],
      ids: json['IDs'] ?? json['ids'],
      userLevel: json['UserLevel'] ?? json['userLevel'],
      mainMenu: MenuType.fromKey(mainMenuStr),
      subMenu: SubMenuType.fromKey(subMenuStr),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Branch': branch,
      'Type': type,
      'IDs': ids,
      'UserLevel': userLevel,
      'MainMenu': mainMenu?.key,
      'SubMenu': subMenu?.key,
    };
  }
}
