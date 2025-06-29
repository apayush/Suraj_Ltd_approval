import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:suraj_approval/ui/utills/constants/radius_utils.dart';
import 'package:get/get.dart';
import '../../../controllers/sidebarx_controller.dart';
import '../../widgets/app_module_container.dart';
import 'app_colors.dart';
import 'app_strings.dart';

class AppImageAssets extends StatelessWidget {
  final String assets;
  final double height;
  final double width;
  final BoxFit? fit;

  const AppImageAssets(this.assets,
      {super.key, required this.height, required this.width, this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assets,
      package: 'shared_component',
      height: height,
      width: width,
      fit: fit, // or any fit you need
    );
  }
}

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Alignment alignment;
  final bool softWrap;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(this.text,
      {super.key,
        required this.style,
        this.alignment = Alignment.centerLeft,
        this.softWrap = false,
        this.maxLines,
        this.overflow});

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
        ));
  }
}

class SidebarXDrawer extends StatelessWidget {
  final List<SidebarXItem> items;
  final SidebarXController controller;

  SidebarXDrawer({
    super.key,
    required this.items,
    required this.controller
  });

  final sideBarXController = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SidebarX(
          controller: controller,
          animationDuration: const Duration(milliseconds: 150),
          showToggleButton: false,
          theme: SidebarXTheme(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: AppColors.darkDrawerBackgroundColor,
            ),
            iconTheme: const IconThemeData(
              color: Colors.grey,
              size: 20,
            ),
            hoverColor: Colors.white,
            hoverTextStyle: TextStyles.normal(context, textColor: Colors.white),
            hoverIconTheme: const IconThemeData(
              color: Colors.white,
              size: 20,
            ),
            selectedItemDecoration: BoxDecoration(
              color: Colors.grey.shade900,
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: const BorderRadius.all(RadiusUtils.mediumRadius),
            ),
            selectedItemTextPadding: const EdgeInsets.only(left: 15),
            itemTextPadding: const EdgeInsets.only(left: 15),
            textStyle: TextStyles.normal(context, textColor: Colors.grey),
            selectedTextStyle:
            TextStyles.normal(context, textColor: Colors.white),
            selectedIconTheme: const IconThemeData(
              color: Colors.white,
              size: 20,
            ),
          ),
          extendedTheme: const SidebarXTheme(
            width: 220,
          ),
          headerBuilder: (context, extended) {
            return SizedBox(
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: extended
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    if (extended) ...[
                      Expanded(child: AppText('Ayush', style: TextStyles.normal(context, textColor: Colors.white))),
                    ],
                    IconButton(
                        onPressed: () {
                          controller.toggleExtended();
                        },
                        icon: const Icon(CupertinoIcons.bars,
                            color: Colors.white)),
                  ],
                ),
              ),
            );
          },
          items: items,
          footerBuilder: (context, extended) {
            final bottomPanel = buildDrawerBottomPanel(context, extended ? false : true);
            return Column(
              children: [
                buildDivider(),
                const SizedBox(height: 10),
                extended ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 60.0,
                  child: Row(
                    children: [
                      bottomPanel,
                    ],
                  ),
                ) : Column(
                  children: [
                    bottomPanel,
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget buildDrawerBottomPanel(BuildContext mContext, bool isVertical) {
    return ValueListenableBuilder<bool>(
      valueListenable: sideBarXController.isProfileExpanded,
      builder: (context, isExpanded, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isVertical
              ? isExpanded
              ? 125
              : 40
              : null,
          width: !isVertical
              ? isExpanded
              ? 125
              : 40
              : null,
          child: isVertical
              ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildLogout(mContext)
            ],
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildLogout(mContext)
            ],
          ),
        );
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
    return Expanded(
      child: IconButton(
        tooltip: AppStrings.logOut,
        icon: const Icon(
          CupertinoIcons.square_arrow_right,
          color: Colors.grey,
        ),
        onPressed: () {
          sideBarXController.navigateToLoginScreen(context);
        },
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final double? width;
  final Color backgroundColor;
  final bool isCancelButton;

  const AppButton(
      {super.key,
        required this.onPressed,
        required this.text,
        this.width,
        this.backgroundColor = AppColors.blue,
        this.isCancelButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
      width /*?? MediaQuery
          .of(context)
          .size
          .width*/
      ,
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
                isCancelButton ? Colors.grey.shade200 : backgroundColor),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: RadiusUtils.borderRadiusForButtons,
                ))),
        child: AppText(text,
            alignment: Alignment.center,
            style: TextStyles.normal(context,
                textColor: isCancelButton ? Colors.black : Colors.white)),
      ),
    );
  }
}

Widget buildDivider() {
  return Divider(
    color: Colors.grey[300],
    height: 0.2,
    thickness: 0.2,
  );
}