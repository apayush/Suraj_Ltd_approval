import 'package:suraj_approval/core/constants/app_enum.dart';

class NotificationModel {
  final String? title;
  final String? body;
  final MenuType? mainType;
  final SubMenuType? subType;
  final String? sent;
  final String? srl;
  final int? nid;
  final bool? isSuccess;

  NotificationModel({
    this.title,
    this.body,
    this.mainType,
    this.subType,
    this.sent,
    this.nid,
    this.isSuccess,
    this.srl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['Title'],
      body: json['Body'],
      mainType: MenuType.fromKey(json['MainType']),
      subType: SubMenuType.fromKey(json['SubType']),
      sent: json['SentAt'],
      nid: json['Nid'],
      isSuccess: json['IsSuccess'],
      srl: json['Srl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Body': body,
      'MainType': mainType?.key,
      'SubType': subType?.key,
      'SentAt': sent,
      'Nid': nid,
      'IsSuccess': isSuccess,
      'Srl': srl,
    };
  }
}
