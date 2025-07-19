class NotificationModel {
  final String? title;
  final String? body;
  final String? mainType;
  final String? subType;
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
      title: json['Title'] as String?,
      body: json['Body'] as String?,
      mainType: json['MainType'] as String?,
      subType: json['SubType'] as String?,
      sent: json['SentAt'] as String?, // Optional, if exists in API
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Body': body,
      'MainType': mainType,
      'SubType': subType,
      'SentAt': sent,
    };
  }
}
