import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_constants.dart';
import 'package:suraj_approval/core/constants/app_images.dart';
import 'package:suraj_approval/core/router/app_router.dart';
import 'package:suraj_approval/core/service/local_db.dart';
import 'package:suraj_approval/core/service/notification_service.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  @override
  void onInit() {
    super.onInit();
    NotificationService.updateBadgeCount(0);
  }

  final List<OnboardingData> onboardingPages = [
    OnboardingData(
      title: 'Smart ERP, Smarter Approvals',
      subtitle: 'See vouchers, orders & approvals—all in one dashboard.',
      imagePath: AppImages.onboarding1,
    ),
    OnboardingData(
      title: 'Instant Actions, Anywhere',
      subtitle: 'Approve or reject entries securely from your mobile device.',
      imagePath: AppImages.onboarding2,
    ),
    OnboardingData(
      title: 'Seamless Workflow, Clear Control',
      subtitle:
          'Efficient filtering, search, and detail views—designed for speed.',
      imagePath: AppImages.onboarding3,
    ),
  ];

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      currentPage.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login
      LocalDB.setBool(AppConstants.isOnBoardingComplete, true);
      Get.offAllNamed(AppRouter.login);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    LocalDB.setBool(AppConstants.isOnBoardingComplete, true);
    Get.offAllNamed(AppRouter.login);
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}
