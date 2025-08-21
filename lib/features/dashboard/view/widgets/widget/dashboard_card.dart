import 'package:flutter/material.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';
import '../../../../../core/models/dashboard_model.dart';
import '../../../../../core/utills/app_module_container.dart';
import '../../../../../core/widgets/common_widgets.dart';

class DashboardCard extends StatelessWidget {
  final DashboardModel model;

  const DashboardCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final totalCount = model.approveCount + model.rejectCount;
    final approvePercentage =
        totalCount > 0 ? (model.approveCount / totalCount) * 100 : 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColors.blue.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getPeriodIcon(model.displayPeriod),
                    color: AppColors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    model.displayPeriod,
                    style: TextStyles.large(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                ),
                // Total count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total: $totalCount',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress indicator
            if (totalCount > 0) ...[
              Row(
                children: [
                  Text('Approve Ratio  ', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.grey[200],
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: approvePercentage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: LinearGradient(
                              colors: [Colors.green[400]!, Colors.green[600]!],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${approvePercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: _buildCountBox(
                    icon: Icons.check_circle_rounded,
                    color: Colors.green,
                    label: 'Approved',
                    count: model.approveCount,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCountBox(
                    icon: Icons.cancel_rounded,
                    color: Colors.red,
                    label: 'Rejected',
                    count: model.rejectCount,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBox({
    required IconData icon,
    required Color color,
    required String label,
    required int count,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getPeriodIcon(String period) {
    switch (period.toLowerCase()) {
      case 'today':
        return Icons.today_rounded;
      case 'this week':
        return Icons.date_range_rounded;
      case 'this month':
        return Icons.calendar_month_rounded;
      default:
        return Icons.analytics_rounded;
    }
  }
}
