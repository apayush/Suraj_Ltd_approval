import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/constants/app_images.dart';
import '../../ui/utills/app_module_container.dart';
import '../theme/app_colors.dart';
import 'common_widgets.dart';

class AppFooter extends StatelessWidget implements PreferredSizeWidget {
  const AppFooter({super.key});

  @override
  Size get preferredSize =>
      const Size.fromHeight(30.0); // Set height of the header

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => buildMobileFooter(context),
      tablet: (context) => buildWebFooter(context),
      desktop: (context) => buildWebFooter(context)
    );
  }

  Widget buildWebFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      color: AppColors.darkDrawerBackgroundColor,
      height: 40.0,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [buildPoweredBy(context)],
          ),
          InkWell(
            onTap: () {
              // openLink('https://www.weservecodes.com');
            },
            child: AppImageAssets(
              AppImages.verticalPvtLogo,
              height: 30.0,
              width: 70.0,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobileFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      color: AppColors.darkDrawerBackgroundColor,
      height: 40.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildPoweredBy(context),
        ],
      ),
    );
  }

  Widget buildPoweredBy(BuildContext context) {
    return Expanded(
        child: InkWell(
          onTap: () {
            // openLink('https://www.weservecodes.com');
          },
          child: AppText(
            '© ${DateTime.now().year} Powered By Vertical Infonet Pvt. Ltd.',
            alignment: Alignment.center,
            style: TextStyles.small(context, textColor: Colors.white),
          ),
        ));
  }
}
