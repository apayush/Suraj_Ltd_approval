import 'package:flutter/material.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../feature/controller/dashboard_controllers/dashboard_controller.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../utills/app_module_container.dart';

class DashboardWeb extends StatelessWidget {
  DashboardWeb({super.key});

  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        // appBar: CustomHeader(),
        body: Center(
          child: AppText('Dashboard Web', style: TextStyles.normal(context),alignment: Alignment.center,),
        )
    );
  }
}