import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../feature/controller/finance_controllers/finance_controller.dart';
import '../../../utills/app_module_container.dart';

class FinanceTablet extends StatelessWidget {
  FinanceTablet({super.key});

  final controller = FinanceController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: Center(
          child: AppText('Finance Tablet', style: TextStyles.normal(context),alignment: Alignment.center,),
        )
    );
  }
}