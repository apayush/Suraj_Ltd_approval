import 'package:flutter/material.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

import '../constants/app_images.dart';
import 'notification.dart';

/// Custom app header — a plain [Container] row, no [AppBar].
/// The parent [AppScaffold] places this inside a [SafeArea] + [Column],
/// so status-bar padding is handled at the scaffold level.
class CustomHeader extends StatelessWidget {
  final Widget? title;

  const CustomHeader({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      height: kToolbarHeight,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          // ── Left: hamburger (mobile) or logo (tablet/web) ─────────────
          if (isMobile)
            IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu, color: AppColors.lightIconThemeColor),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                AppImages.surajPvtLogo,
                height: kToolbarHeight - 16,
                fit: BoxFit.contain,
              ),
            ),

          // ── Mobile logo ───────────────────────────────────────────────
          if (isMobile)
            Image.asset(
              AppImages.surajPvtLogo,
              height: 30,
              fit: BoxFit.contain,
            ),

          // ── Title ─────────────────────────────────────────────────────
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: title!,
            ),

          const Spacer(),

          // ── Notification bell ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: NotificationBell(),
          ),
        ],
      ),
    );
  }
}
