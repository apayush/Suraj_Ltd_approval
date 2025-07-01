import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'widgets/login_view_tablet.dart';
import 'widgets/login_view_web.dart';
import 'widgets/loin_view_mobile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => LoginViewMobile(),
      tablet: (context) => LoginViewTablet(),
      desktop: (context) => LoginViewWeb(),
    );
  }
}
