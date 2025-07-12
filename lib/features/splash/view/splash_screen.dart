import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/features/splash/view/widget/suraj_splash_animation.dart';

import '../../../core/router/app_router.dart';

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
          // 🔁 Delay optional: just to see the end of animation
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed(AppRouter.onboardingScreen);
          });
        },
      ),
    );
  }
}
