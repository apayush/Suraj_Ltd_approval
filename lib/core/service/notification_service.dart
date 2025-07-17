import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handlerBackgroundMessage(RemoteMessage message) async {
  //handle background notification when application is on terminat state.
}

class NotificationService {
  static final localNotification = FlutterLocalNotificationsPlugin();
  static late final _androidNotificationChannel;
  static late final _notificationChannelName;

  static Future<void> initialize() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );

      if (!kIsWeb) {
        final androidInitSettings = AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        );

        _notificationChannelName = 'Suraj Approval Notification Channel';
        _androidNotificationChannel = AndroidNotificationChannel(
          'Suraj Approval',
          _notificationChannelName,
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
          showBadge: true,
        );

        final initialSetting = InitializationSettings(
          android: androidInitSettings,
        );
        await localNotification.initialize(initialSetting);

        await localNotification
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(_androidNotificationChannel);
      }

      FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
      FirebaseMessaging.onMessage.listen(onFirebaseNotificationReceived);

      if (kIsWeb) {
        await setUpNotificationWeb();
      } else {
        if (defaultTargetPlatform == TargetPlatform.android) {
          debugPrint('here is fcmid : ${await getFcmId()}');
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          await FirebaseMessaging.instance.getAPNSToken();
          debugPrint(await getFcmId());
        }
      }
    } catch (e) {
      print("error ${e.toString()}");
    }
  }

  static Future<void> onFirebaseNotificationReceived(
    RemoteMessage message,
  ) async {
    if (Platform.isAndroid) {
      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'Suraj Approval',
          _notificationChannelName,
        ),
      );
      await localNotification.show(
        message.hashCode,
        message.notification?.title ?? 'Title not available',
        message.notification?.body ?? 'Message not available',
        notificationDetails,
      );
    }
  }

  static Future<String> getFcmId() async {
    String fcmId = '';
    try {
      fcmId = await FirebaseMessaging.instance.getToken() ?? '';
    } catch (e) {
      fcmId = '';
    }
    print('FCM ID: $fcmId');
    return fcmId;
  }

  static Future<void> setUpNotificationWeb() async {}
}
