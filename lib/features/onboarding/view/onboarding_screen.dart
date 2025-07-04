import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'widgets/onboarding_view_mobile.dart';
import 'widgets/onboarding_view_tablet.dart';
import 'widgets/onboarding_view_web.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => const OnboardingViewMobile(),
      tablet: (context) => const OnboardingViewTablet(),
      desktop: (context) => const OnboardingViewWeb(),
    );
  }
}
