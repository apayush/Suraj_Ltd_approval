import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/dashboard_mobile.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/dashboard_tablet.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/dashboard_web.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controller/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children : [
        ScreenTypeLayout.builder(
          mobile: (context) => DashboardMobile(),
          tablet: (context) => DashboardTablet(),
          desktop: (context) => DashboardWeb(),
        ),
        LoaderWidget(controller: controller)
      ]
    );
  }
}
