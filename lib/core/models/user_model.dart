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
    return UserModel(
      mUser: json['mUser'],
      fcmid: json['fcmid'],
      userDetails:
          (json['userDetails'] as List)
              .map((e) => UserDetails.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mUser': mUser,
      'fcmid': fcmid,
      'userDetails': userDetails.map((e) => e.toJson()).toList(),
    };
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
    return UserDetails(
      branch: json['Branch'],
      type: json['Type'],
      ids: json['IDs'],
      userLevel: json['UserLevel'],
      mainMenu: MenuType.fromKey(json['MainMenu']),
      subMenu: SubMenuType.fromKey(json['SubMenu']),
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
