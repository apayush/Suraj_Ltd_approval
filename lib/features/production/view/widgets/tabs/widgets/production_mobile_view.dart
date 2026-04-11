import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';

import '../../daywise_module/daywise_tab_view.dart';
import '../../hourly_module/hourly_tab_view.dart';
import '../../lg30_module/lg30_pilger_tab_view.dart';
import '../../daily_module/daily_production_tab_view.dart';
import '../../ffd_module/ffd_tab_view.dart';

class ProductionMobileView extends StatelessWidget {
  const ProductionMobileView({super.key, required this.subMenuType});
  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    switch (subMenuType) {
      case SubMenuType.hourlyProductionEntry:
        return const HourlyTabView(columns: 1);
      case SubMenuType.MPDSPDDaywiseEntry:
        return const DaywiseTabView(columns: 1);
      case SubMenuType.lg30PilgerEntry:
        return const LG30PilgerTabView(columns: 1);
      case SubMenuType.dailyProduction:
        return const DailyProductionTabView(columns: 1);
      case SubMenuType.ffdFormingProduction:
        return const FFDTabView(columns: 1);
      default:
        return Center(
          child: AppText(
            '${subMenuType.key} — Coming Soon',
            style: TextStyles.normal(Get.context!),
          ),
        );
    }
  }
}
