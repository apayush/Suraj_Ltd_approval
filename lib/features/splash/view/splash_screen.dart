import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAllNamed(AppRouter.onboarding);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
