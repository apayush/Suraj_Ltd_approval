import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_images.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final int? notificationCount;
  final VoidCallback? onNotificationPressed;

  const CustomHeader({
    super.key,
    this.bottom,
    this.notificationCount,
    this.onNotificationPressed,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    // final appBarTheme = Theme.of(context).appBarTheme;

    return AppBar(
      // elevation: appBarTheme.elevation ?? 2.0, // Use theme value
      // backgroundColor: appBarTheme.color, // Use theme value
      // shadowColor: appBarTheme.shadowColor, // Use theme value
      // surfaceTintColor: appBarTheme.surfaceTintColor, // Optional: add to your theme if needed
      // automaticallyImplyLeading: isMobile,
      // titleSpacing: 0,
      // iconTheme: appBarTheme.iconTheme,
      //
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: isMobile,
      titleSpacing: 0,
      title: Row(
        children: [
          if (!isMobile)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                AppImages.surajPvtLogo,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          if (isMobile)
            const SizedBox(width: 8),
          if (isMobile)
            Image.asset(
              AppImages.surajPvtLogo,
              height: 30,
              fit: BoxFit.contain,
            ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IconButton(
            icon: Stack(
              children: [
                const Icon(CupertinoIcons.bell_fill, color: Colors.black),
                if (notificationCount != null && notificationCount! > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationCount!.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: onNotificationPressed,
          ),
        ),
      ],
      centerTitle: false,
      bottom: bottom,
    );
  }
}
