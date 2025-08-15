import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/models/dashboard_model.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/widgets/loading_widget.dart';
import 'package:suraj_approval/core/widgets/no_data_found.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/widget/dashboard_card.dart';

import '../../../../core/utills/app_module_container.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../features/dashboard/controller/dashboard_controller.dart';

class DashboardMobile extends StatelessWidget {
  DashboardMobile({super.key});

  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppText('Dashboard', style: TextStyles.extraLarge(context)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.blue.withOpacity(0.05), Colors.white],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return LoaderWidget(controller: controller);
          }
          return RefreshIndicator(
            onRefresh: () async {
              await controller.getVoucherApprovalDashboard();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blue,
                          AppColors.blue.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: _buildQuickStat(
                                'Approved',
                                controller.dashboardData
                                    .firstWhere(
                                      (p0) => p0.period == 'ThisMonth',
                                      orElse: () => DashboardModel.empty(),
                                    )
                                    .approveCount,
                                Icons.verified_rounded,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            Expanded(
                              child: _buildQuickStat(
                                'Rejected',
                                controller.dashboardData
                                    .firstWhere(
                                      (p0) => p0.period == 'ThisMonth',
                                      orElse: () => DashboardModel.empty(),
                                    )
                                    .rejectCount,
                                Icons.cancel_outlined,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            Expanded(
                              child: _buildQuickStat(
                                'Total Requests',
                                controller.dashboardData
                                    .where((p0) => p0.period == 'ThisMonth')
                                    .fold(
                                      0,
                                      (sum, item) =>
                                          sum +
                                          item.approveCount +
                                          item.rejectCount,
                                    ),
                                Icons.assignment_turned_in_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  AppText(
                    'Detailed Breakdown',
                    style: TextStyles.large(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                  if (controller.dashboardData.isEmpty)
                    const Center(child: NoDataFound())
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.dashboardData.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = controller.dashboardData[index];
                        return DashboardCard(model: item);
                      },
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuickStat(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)),
        ),
      ],
    );
  }
}
