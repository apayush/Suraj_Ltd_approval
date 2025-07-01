import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../feature/controller/finance_controllers/finance_controller.dart';
import '../../../utills/app_module_container.dart';

class FinanceWeb extends StatelessWidget {
  FinanceWeb({super.key});

  final controller = FinanceController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: Center(
          child: AppText('Finance Web', style: TextStyles.normal(context),alignment: Alignment.center,),
        )
    );
  }
}