import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/features/dashboard/controller/app_drawer_controller.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/dashboard_mobile.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/dashboard_tablet.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/dashboard_web.dart';

import '../../../core/widgets/loading_widget.dart';
import '../controller/dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = DashboardController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<AppDrawerController>().setSelectedMenuDrawer(MenuType.dashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScreenTypeLayout.builder(
          mobile: (context) => DashboardMobile(),
          tablet: (context) => DashboardTablet(),
          desktop: (context) => DashboardWeb(),
        ),
        LoaderWidget(controller: controller),
      ],
    );
  }
}
