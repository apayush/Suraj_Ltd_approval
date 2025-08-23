import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/features/purchase/view/widgets/tabs/widgets/purchase_mobile_view.dart';
import 'package:suraj_approval/features/purchase/view/widgets/tabs/widgets/purchase_tablet_view.dart';
import 'package:suraj_approval/features/purchase/view/widgets/tabs/widgets/purchase_web_view.dart';
import 'package:suraj_approval/features/sales/view/widgets/tabs/widgets/sales_mobile_view.dart';
import 'package:suraj_approval/features/sales/view/widgets/tabs/widgets/sales_tablet_view.dart';
import 'package:suraj_approval/features/sales/view/widgets/tabs/widgets/sales_web_view.dart';

class SalesView extends StatelessWidget {
  const SalesView({super.key, required this.subMenuType});

  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => SalesMobileView(subMenuType: subMenuType),
      tablet: (context) => SalesTabletView(subMenuType: subMenuType),
      desktop: (context) => SalesWebView(subMenuType: subMenuType),
    );
  }
}
