import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:suraj_approval/core/service/local_db.dart';

import '../../features/dashboard/controller/sidebarx_controller.dart';
import '../constants/app_strings.dart';
import '../constants/radius_utils.dart';
import '../theme/app_colors.dart';
import '../utills/app_module_container.dart';

class AppImageAssets extends StatelessWidget {
  final String assets;
  final double height;
  final double width;
  final BoxFit? fit;

  const AppImageAssets(
    this.assets, {
    super.key,
    required this.height,
    required this.width,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(assets, height: height, width: width, fit: fit);
  }
}

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Alignment alignment;
  final bool softWrap;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    required this.style,
    this.alignment = Alignment.centerLeft,
    this.softWrap = false,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: style,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        // overflow: TextOverflow.visible, // Ensure overflow text is visible
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  final String tooltip;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip = '',
    this.iconSize = 20.0,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: 45.0,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        borderRadius: RadiusUtils.borderRadiusForButtons,
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Tooltip(
        message: tooltip, // Tooltip for the button
        child: ClipRRect(
          // Ensure the icon respects the border radius
          borderRadius: RadiusUtils.borderRadiusForButtons,
          child: Material(
            color: Colors.transparent,
            // Use transparent to inherit container's color
            child: InkWell(
              borderRadius: RadiusUtils.borderRadiusForButtons,
              onTap: onPressed, // Button action
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).primaryColorDark,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget appGridLabel(String label, {Alignment align = Alignment.centerLeft}) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    alignment: Alignment.centerLeft,
    child: AppText(
      label,
      alignment: align,
      style: TextStyles.normal(Get.context!, textColor: Colors.white),
    ),
  );
}

class SidebarXDrawer extends StatelessWidget {
  final List<SidebarXItem> items;
  final SidebarXController controller;

  SidebarXDrawer({super.key, required this.items, required this.controller});

  final sideBarXController = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      animationDuration: Duration.zero,
      // animationDuration: const Duration(milliseconds: 150),
      showToggleButton: false,
      theme: SidebarXTheme(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
          color: AppColors.darkDrawerBackgroundColor,
        ),
        iconTheme: const IconThemeData(color: Colors.grey, size: 20),
        hoverColor: Colors.white,
        hoverTextStyle: TextStyles.normal(context, textColor: Colors.white),
        hoverIconTheme: const IconThemeData(color: Colors.white, size: 20),
        selectedItemDecoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: const BorderRadius.all(RadiusUtils.mediumRadius),
        ),
        selectedItemTextPadding: const EdgeInsets.only(left: 15),
        itemTextPadding: const EdgeInsets.only(left: 15),
        textStyle: TextStyles.normal(context, textColor: Colors.grey),
        selectedTextStyle: TextStyles.normal(context, textColor: Colors.white),
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 20),
      ),
      extendedTheme: const SidebarXTheme(width: 220),
      headerBuilder: (context, extended) {
        final userModel = LocalDB.getUserModel();
        final username = userModel?.mUser ?? 'User';
        return SafeArea(
          child: SizedBox(
            height: 60.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment:
                    extended
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                children: [
                  if (extended) ...[
                    Expanded(
                      child: AppText(
                        '$username',
                        style: TextStyles.medium(
                          context,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  IconButton(
                    onPressed: () {
                      controller.toggleExtended();
                    },
                    icon: const Icon(CupertinoIcons.bars, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      items: items,
      footerBuilder: (context, extended) {
        final bottomPanel = buildDrawerBottomPanel(
          context,
          extended ? false : true,
        );
        return SafeArea(
          child: Column(
            children: [
              buildDivider(),
              const SizedBox(height: 10),
              Column(children: [bottomPanel]),
            ],
          ),
        );
      },
    );
  }

  Widget buildDrawerBottomPanel(BuildContext mContext, bool isVertical) {
    return ValueListenableBuilder<bool>(
      valueListenable: sideBarXController.isProfileExpanded,
      builder: (context, isExpanded, child) {
        return Column(children: [buildLogout(mContext)]);
      },
    );
  }

  Widget buildVersion(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return AppText(
            '(${sideBarXController.appVersion})',
            alignment: Alignment.centerRight,
            style: TextStyles.small(context, textColor: Colors.white),
          );
        }),
      ),
    );
  }

  Widget buildLogout(BuildContext context) {
    return IconButton(
      tooltip: AppStrings.logOut,
      icon: const Icon(CupertinoIcons.square_arrow_right, color: Colors.grey),
      onPressed: () {
        sideBarXController.navigateToLoginScreen(context);
      },
    );
  }

  Widget buildSetting(BuildContext context) {
    return IconButton(
      tooltip: AppStrings.settings,
      icon: const Icon(CupertinoIcons.gear_solid, color: Colors.grey),
      onPressed: () {
        sideBarXController.navigateToSettingDialog(context);
      },
    );
  }
}

class AppButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final double? width;
  final Color backgroundColor;
  final bool isCancelButton;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.backgroundColor = AppColors.blue,
    this.isCancelButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width /*?? MediaQuery
          .of(context)
          .size
          .width*/,
      height: 40.0,
      decoration: BoxDecoration(
        border:
            isCancelButton ? Border.all(color: Colors.grey, width: 0.5) : null,
        borderRadius: RadiusUtils.borderRadiusForButtons,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            isCancelButton ? Colors.grey.shade200 : backgroundColor,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: RadiusUtils.borderRadiusForButtons,
            ),
          ),
        ),
        child: AppText(
          text,
          alignment: Alignment.center,
          style: TextStyles.normal(
            context,
            textColor: isCancelButton ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget buildDivider() {
  return Divider(color: Colors.grey[300], height: 0.2, thickness: 0.2);
}
