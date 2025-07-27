import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/finance_mobile_view.dart';
import 'package:suraj_approval/features/finance/view/widgets/tabs/widgets/finance_tablet_view.dart';

import 'finance_web_view.dart';

class FinanceView extends StatelessWidget {
  const FinanceView({super.key, required this.subMenuType});

  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => FinanceMobileView(subMenuType: subMenuType),
      tablet: (context) => FinanceTabletView(subMenuType: subMenuType),
      desktop: (context) => FinanceWebView(subMenuType: subMenuType),
    );
  }
}
