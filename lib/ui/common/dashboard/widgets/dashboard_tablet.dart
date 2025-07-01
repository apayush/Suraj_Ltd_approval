import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../feature/controller/dashboard_controllers/dashboard_controller.dart';
import '../../../utills/app_module_container.dart';

class DashboardTablet extends StatelessWidget {
  DashboardTablet({super.key});

  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: Center(
          child: AppText('Dashboard Tablet', style: TextStyles.normal(context),alignment: Alignment.center,),
        )
    );
  }
}