import 'package:flutter/material.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

import '../constants/app_images.dart';
import 'notification.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final int? notificationCount;
  final Widget? title;

  const CustomHeader({
    super.key,
    this.bottom,
    this.notificationCount,
    this.title,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SafeArea(
      child: AppBar(
        leading:
            isMobile
                ? IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(Icons.menu, color: AppColors.lightIconThemeColor),
                )
                : null,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: isMobile,
        titleSpacing: 0,
        title: Row(
          children: [
            if (!isMobile)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: kToolbarHeight - 8,
                  child: Image.asset(
                    AppImages.surajPvtLogo,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            if (isMobile) const SizedBox(width: 8),
            if (isMobile)
              Image.asset(
                AppImages.surajPvtLogo,
                height: 30,
                fit: BoxFit.contain,
              ),
            if (title != null)
              Padding(padding: const EdgeInsets.only(left: 10), child: title!),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: NotificationBell(),
          ),
        ],
        centerTitle: false,
        bottom: bottom,
      ),
    );
  }
}
