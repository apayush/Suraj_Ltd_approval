import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/widgets/header.dart';
import '../../../controllers/dashboard_controllers/dashboard_controller.dart';
import '../../utills/constants/app_strings.dart';
import '../../widgets/app_module_container.dart';
import '../../widgets/common_widgets/app_scaffold.dart';
import '../../widgets/common_widgets/sidebar_drawer.dart';

abstract class DashboardBase extends StatelessWidget {
  DashboardBase({super.key});

  bool get isMobile;
  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBar: Header(
          title: AppStrings.appName,
        ),
        drawer: isMobile ? const AppDrawer() : null,
        body: AppModuleContainer(items: controller.appModules)
    );
  }
}
