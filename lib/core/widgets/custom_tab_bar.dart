import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

/// A controller-free tab bar that uses [RxInt] for state.
/// Visually matches Flutter's [TabBar] with a blue bottom indicator.
class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final RxInt selectedIndex;
  final void Function(int index) onTap;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? Colors.grey.shade900 : Colors.white,
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(() {
            return Row(
              children: List.generate(tabs.length, (i) {
                final isSelected = selectedIndex.value == i;
                return _TabItem(
                  label: tabs[i],
                  isSelected: isSelected,
                  isDark: isDark,
                  onTap: () {
                    if (!isSelected) onTap(i);
                  },
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color:
                isSelected
                    ? AppColors.blue
                    : (isDark ? Colors.white54 : Colors.grey),
          ),
        ),
      ),
    );
  }
}
