import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/models/dashboard_model.dart';
import '../../../../../core/utills/app_module_container.dart';
import '../../../../../core/theme/app_colors.dart';

class ModernDashboardTile extends StatefulWidget {
  final DashboardModel model;
  final VoidCallback? onTap;
  final double borderRadius;
  final double elevation;

  const ModernDashboardTile({
    Key? key,
    required this.model,
    this.onTap,
    this.borderRadius = 18,
    this.elevation = 8,
  }) : super(key: key);

  @override
  State<ModernDashboardTile> createState() => _ModernDashboardTileState();
}

class _ModernDashboardTileState extends State<ModernDashboardTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final totalCount = model.approveCount + model.rejectCount;
    final approvePercentage =
    totalCount > 0 ? (model.approveCount / totalCount) * 100 : 0;

    final Gradient iconGradient = LinearGradient(
      colors: [AppColors.blue.withOpacity(0.8), AppColors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final bool isWeb = Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux;

    final tile = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: _hover ? widget.elevation + 6 : widget.elevation,
                offset: Offset(0, _hover ? 10 : 6),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon badge
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: iconGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getPeriodIcon(model.displayPeriod),
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Period title
              Text(
                model.displayPeriod,
                style: TextStyles.large(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 6),

              // Total badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Total: $totalCount",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Approve ratio progress bar
              if (totalCount > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Approve Ratio",
                        style: TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(width: 6),
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
                                colors: [
                                  Colors.green[400]!,
                                  Colors.green[600]!
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${approvePercentage.toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Approved & Rejected counts
              Row(
                children: [
                  Expanded(
                    child: _buildMiniBox(
                      icon: Icons.check_circle_rounded,
                      color: Colors.green,
                      count: model.approveCount,
                      label: "Approved",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniBox(
                      icon: Icons.cancel_rounded,
                      color: Colors.red,
                      count: model.rejectCount,
                      label: "Rejected",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );

    final interactive = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTap: widget.onTap,
        onHover: (h) {
          if (isWeb) setState(() => _hover = h);
        },
        child: tile,
      ),
    );

    return MouseRegion(
      cursor: _hover ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: _hover ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 160),
        child: interactive,
      ),
    );
  }

  Widget _buildMiniBox({
    required IconData icon,
    required Color color,
    required int count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            "$count",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  IconData _getPeriodIcon(String period) {
    switch (period.toLowerCase()) {
      case "today":
        return Icons.today_rounded;
      case "this week":
        return Icons.date_range_rounded;
      case "this month":
        return Icons.calendar_month_rounded;
      default:
        return Icons.analytics_rounded;
    }
  }
}
