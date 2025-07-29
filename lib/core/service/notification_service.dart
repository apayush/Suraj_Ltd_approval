import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_constants.dart';
import 'package:suraj_approval/prepare_initial_route.dart';

import '../../features/notifications/controller/notification_controller.dart';

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
          // sound: RawResourceAndroidNotificationSound('notification'),
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
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        final controller = Get.find<NotificationController>();
        onFirebaseNotificationReceived(message);
        await controller.fetchNotifications();
      });
      // FirebaseMessaging.onMessage.listen(onFirebaseNotificationReceived);
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
      fcmId =
          await FirebaseMessaging.instance.getToken(
            vapidKey: kIsWeb ? AppConstants.fcmWebKeyPair : null,
          ) ??
          '';
    } catch (e) {
      fcmId = '';
    }
    return fcmId;
  }

  static Future<void> setUpNotificationWeb() async {}

  static void onMessageOpenedApp(RemoteMessage message) {
    final result = prepareInitialRoute(message);
    Get.offAllNamed(result.route, arguments: result.argument);
  }

  static Future<void> deleteFCMToken() async {
    if (kIsWeb) return;
    await FirebaseMessaging.instance.deleteToken();
  }
}
