import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/material_item_model.dart';
import '../utills/constants/app_colors.dart';
import '../utills/constants/radius_utils.dart';
import 'common_widgets/app_text.dart';

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
  const ItemWithIconContainerWidget(
      {super.key, required this.value, this.dialog});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 150.0,
      child: Card(
        color: AppColors.blue.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: RadiusUtils.borderRadiusMedium,
          side: const BorderSide(
            color: Colors.grey,
            width: 0.1,
          ),
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

                Icon(
                  value.icon,
                  size: 45,
                  color: AppColors.blue,
                ),

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

