import 'package:flutter/material.dart';

import '../../../../core/utills/app_module_container.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../features/dashboard/controller/dashboard_controller.dart';

class DashboardWeb extends StatelessWidget {
  DashboardWeb({super.key});

  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Dashboard', style: TextStyle(color: Colors.black)),
      body: Center(
        child: AppText(
          'Dashboard Web',
          style: TextStyles.normal(context),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
