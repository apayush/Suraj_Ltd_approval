import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/features/splash/view/widget/suraj_splash_animation.dart';
import 'package:suraj_approval/prepare_initial_route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SurajSplashAnimation(
        onAnimationComplete: () {
          Future.delayed(const Duration(milliseconds: 500), () async {
            final message =
                await FirebaseMessaging.instance.getInitialMessage();
            final result = await prepareInitialRoute(message);

            Get.offAllNamed(result.route, arguments: result.argument);
          });
        },
      ),
    );
  }
}
