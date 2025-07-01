import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/ui/common/sales_module/widgets/sales_mobile.dart';
import 'package:suraj_approval/ui/common/sales_module/widgets/sales_tablet.dart';
import 'package:suraj_approval/ui/common/sales_module/widgets/saless_web.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => SalesMobile(),
      tablet: (context) => SalesTablet(),
      desktop: (context) => SalesWeb(),
    );
  }
}
