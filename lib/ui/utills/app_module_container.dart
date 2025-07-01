import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/radius_utils.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../feature/model/material_item_model.dart';

class AppModuleContainer extends StatelessWidget {
  final List<MaterialItem> items;
  const AppModuleContainer({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List.generate(
          items.length,
          (index) => ItemWithIconContainerWidget(value: items[index]),
        ),
      ),
    );
  }
}

class ItemWithIconContainerWidget extends StatelessWidget {
  final MaterialItem value;
  final Widget? dialog;
  const ItemWithIconContainerWidget({
    super.key,
    required this.value,
    this.dialog,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 150.0,
      child: Card(
        color: AppColors.blue.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: RadiusUtils.borderRadiusMedium,
          side: const BorderSide(color: Colors.grey, width: 0.1),
        ),
        child: InkWell(
          onTap: () {
            if (value.isDialog == true) {
              Get.dialog(dialog ?? const SizedBox());
            } else {
              Get.toNamed(value.route ?? '');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                // ! ================================ ICON ===================================
                Icon(value.icon, size: 45, color: AppColors.blue),

                // ! ================================ TEXT ===================================
                AppText(
                  value.title,
                  alignment: Alignment.center,
                  style: TextStyles.small(context),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextStyles {
  static TextStyle extraSmall(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.extraSmall,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle small(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.small,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle normal(
    BuildContext context, {
    Color? textColor,
    double? size,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: size ?? FontSizes.normal,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle normalBold(
    BuildContext context, {
    Color? textColor,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.normal,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle medium(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.medium,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle tabStyle({Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: 15.0,
      color: textColor,
    );
  }

  static TextStyle mediumBold(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.medium,
      fontWeight: FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle large(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.large,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle largeBold(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.large,
      fontWeight: FontWeight.w600,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle extraLarge(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.extraLarge,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle huge(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.huge,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle heading1(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.huge,
      fontWeight: FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.titleLarge?.color,
    );
  }

  static TextStyle heading2(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.extraLarge,
      fontWeight: FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.titleLarge?.color,
    );
  }

  static TextStyle heading3(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.large,
      fontWeight: FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.titleLarge?.color,
    );
  }

  static TextStyle heading4(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.medium,
      fontWeight: FontWeight.w500,
      color: textColor ?? Theme.of(context).textTheme.titleLarge?.color,
    );
  }

  static TextStyle buttonTextStyle(BuildContext context, Color? color) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.small,
      color: color,
    );
  }

  static TextStyle appBarTitle(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      package: 'shared_component',
      fontSize: FontSizes.large,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
      fontWeight: FontWeight.bold,
    );
  }
}

class FontSizes {
  static double extraSmall = 10.0;
  static double small = 12.0;
  static double normal = 13.0;
  static double medium = 15.0;
  static double large = 18.0;
  static double extraLarge = 20.0;
  static double huge = 24.0;
}
