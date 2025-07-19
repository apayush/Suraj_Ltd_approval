import 'package:flutter/material.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';

class NotificationModel {
  final String? title;
  final String? body;
  final MenuType? mainType;
  final SubMenuType? subType;
  final String? sent;

  NotificationModel({
    this.title,
    this.body,
    this.mainType,
    this.subType,
    this.sent,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['Title'],
      body: json['Body'],
      mainType: MenuType.fromKey(json['MainType']),
      subType: SubMenuType.fromKey(json['SubType']),
      sent: json['SentAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Body': body,
      'MainType': mainType?.key,
      'SubType': subType?.key,
      'SentAt': sent,
    };
  }
}
