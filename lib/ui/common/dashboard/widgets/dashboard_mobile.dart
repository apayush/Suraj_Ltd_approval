import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../features/dashboard/controller/dashboard_controller.dart';
import '../../../utills/app_module_container.dart';

class DashboardMobile extends StatelessWidget {
  DashboardMobile({super.key});

  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: AppText(
          'Dashboard Mobile',
          style: TextStyles.normal(context),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
