import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/constants/app_enum.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';

import '../../daywise_module/daywise_tab_view.dart';
import '../../hourly_module/hourly_tab_view.dart';
import '../../lg30_module/lg30_pilger_tab_view.dart';
import '../../ffd_module/ffd_tab_view.dart';

class ProductionTabletView extends StatelessWidget {
  const ProductionTabletView({super.key, required this.subMenuType});
  final SubMenuType subMenuType;

  @override
  Widget build(BuildContext context) {
    switch (subMenuType) {
      case SubMenuType.hourlyProductionEntry:
        return const HourlyTabView(columns: 2);
      case SubMenuType.MPDSPDDaywiseEntry:
        return const DaywiseTabView(columns: 2);
      case SubMenuType.lg30PilgerEntry:
        return const LG30PilgerTabView(columns: 2);
      case SubMenuType.ffdFormingProduction:
        return const FFDTabView(columns: 2);
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
