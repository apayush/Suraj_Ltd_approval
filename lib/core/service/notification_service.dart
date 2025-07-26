import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/prepare_initial_route.dart';

@pragma('vm:entry-point')
Future<void> handlerBackgroundMessage(RemoteMessage message) async {
  print(
    'handlerBackgroundMessagemessage .notification?.title:${message.notification?.title}',
  );
  print(
    'handlerBackgroundMessage message.notification?.body:${message.notification?.body}',
  ); //handle background notification when application is on terminat state.
}

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse details) {
  final data = jsonDecode(details.payload ?? '');
  final result = prepareInitialRoute(
    RemoteMessage(
      notification: RemoteNotification(
        title: data['title'] ?? '',
        body: data['body'] ?? '',
      ),
    ),
  );
  Future.microtask(() {
    if (Get.routing.current != result.route &&
        Get.routing.previous != result.route) {
      Get.offAllNamed(result.route, arguments: result.argument);
    } else if (Get.routing.previous == result.route) {
      Get.back();
      Future.microtask(() {
        gotToSubMenuFromRoute(result.route, result.argument);
      });
    } else if (Get.routing.current == result.route) {
      gotToSubMenuFromRoute(result.route, result.argument);
    }
  });
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
        await localNotification.initialize(
          initialSetting,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        );

        await localNotification
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(_androidNotificationChannel);
      }

      FirebaseMessaging.onBackgroundMessage(handlerBackgroundMessage);
      FirebaseMessaging.onMessage.listen(onFirebaseNotificationReceived);
      FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);

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
    print(message.data);
    print('message.notification?.title:${message.notification?.title}');
    print('message.notification?.body):${(message.notification?.body)}');
    if (Platform.isAndroid || Platform.isIOS) {
      final notificationDetails = NotificationDetails(
        iOS: DarwinNotificationDetails(),
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
        payload: jsonEncode({
          'title': message.notification?.title.toString(),
          'body': message.notification?.body.toString(),
        }),
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

  static void onMessageOpenedApp(RemoteMessage message) {
    print('message.notification?.title:${message.notification?.title}');
    print('message.notification?.body:${message.notification?.body}');
    final result = prepareInitialRoute(message);
    Get.offAllNamed(result.route, arguments: result.argument);
  }

  static Future<void> deleteFCMToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }
}
