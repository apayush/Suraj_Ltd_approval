import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_component/widgets/header.dart';
import '../../../controllers/dashboard_controllers/dashboard_controller.dart';
import '../../utills/constants/app_strings.dart';
import '../../widgets/app_module_container.dart';

abstract class DashboardBase extends StatelessWidget {
  DashboardBase({super.key});

  bool get isMobile;
  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Suraj Pvt Ltd')),
        // drawer: isMobile ? const () : null,
        body: AppModuleContainer(items: controller.appModules)
    );
  }
}
