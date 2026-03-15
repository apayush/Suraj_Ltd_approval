import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/features/production/view/widgets/tabs/widgets/production_mobile_view.dart';
import 'package:suraj_approval/features/production/view/widgets/tabs/widgets/production_tablet_view.dart';
import 'package:suraj_approval/features/production/view/widgets/tabs/widgets/production_web_view.dart';

class ProductionView extends StatelessWidget {
  const ProductionView({super.key, required this.subMenuType});

  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => ProductionMobileView(subMenuType: subMenuType),
      tablet: (context) => ProductionTabletView(subMenuType: subMenuType),
      desktop: (context) => ProductionWebView(subMenuType: subMenuType),
    );
  }
}
