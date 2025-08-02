import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';
import 'package:suraj_approval/core/utills/device_type.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/widgets/loading_widget.dart';
import 'package:suraj_approval/features/dashboard/view/widgets/widget/dashboard_card.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../features/dashboard/controller/dashboard_controller.dart';

class DashboardWeb extends StatelessWidget {
  DashboardWeb({super.key});

  final controller = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppText('Dashboard', style: TextStyles.extraLarge(context)),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.blue.withOpacity(0.05), Colors.white],
          ),
        ),
        child: Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                child: _buildSummaryCard(
                                  'Approved',
                                  controller.dashboardData.fold(
                                    0,
                                    (sum, item) => sum + item.approveCount,
                                  ),
                                  Icons.verified_rounded,
                                  Colors.white,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              Expanded(
                                child: _buildSummaryCard(
                                  'Rejected',
                                  controller.dashboardData.fold(
                                    0,
                                    (sum, item) => sum + item.rejectCount,
                                  ),
                                  Icons.cancel_outlined,
                                  Colors.white,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              Expanded(
                                child: _buildSummaryCard(
                                  'Total Requests',
                                  controller.dashboardData.fold(
                                    0,
                                    (sum, item) =>
                                        sum +
                                        item.approveCount +
                                        item.rejectCount,
                                  ),
                                  Icons.assignment_turned_in_rounded,
                                  Colors.white,
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
                    Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          // maxCrossAxisExten/t: DeviceType.isDesktop(context)?300:  400,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: controller.dashboardData.length,
                        itemBuilder: (context, index) {
                          final item = controller.dashboardData[index];
                          return DashboardCard(model: item);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    int count,
    IconData icon,
    Color textColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: textColor, size: 32),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.9)),
        ),
      ],
    );
  }
}
