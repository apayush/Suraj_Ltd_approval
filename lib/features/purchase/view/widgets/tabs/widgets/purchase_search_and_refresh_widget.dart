import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/constants/app_strings.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/utills/device_type.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/features/purchase/controller/purchase_controller.dart';
import '../../../../../../core/widgets/app_dialog.dart';

class PurchaseSearchAndRefreshWidget extends GetView<PurchaseController> {
  const PurchaseSearchAndRefreshWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenType = getDeviceType(MediaQuery.of(context).size);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (screenType == DeviceType.isMobile(context))
          Expanded(child: buildSearchTextField())
        else
          buildSearchTextField(),
        10.widthGap,
        Row(
            children: [
              if(DeviceType.isDesktop(context))
                buildFilter()
              else
                BuildFilterBtn(),
              10.widthGap,
              buildClearFilterButton(),
            ]
          // children: [buildHoldVoucherButton(), buildClearFilterButton()],
        ),
      ],
    );
  }

  Widget buildSearchTextField() {
    return Flexible(
      child: AppTextField(
        hint: 'Search',
        controller: controller.searchController,
        onChanged: (value) {
          controller.filterData(value);
        },
      ),
    );
  }

  Widget buildHoldVoucherButton() {
    return Obx(() {
      final isHoldVoucher = controller.isHoldVoucherModelEnabled.value;
      return AppIconButton(
        tooltip: AppStrings.hold,
        onPressed: controller.toggleHoldMode,
        icon: CupertinoIcons.pause_circle,
        backgroundColor: isHoldVoucher ? Colors.orange.shade50 : null,
        iconColor: isHoldVoucher ? Colors.orange.shade600 : null,
      );
    });
  }

  Widget buildClearFilterButton() {
    return AppIconButton(
      tooltip: AppStrings.reset,
      onPressed: controller.resetFilters,
      icon: CupertinoIcons.arrow_clockwise,
    );
  }

  Widget buildFilter() {
    return Obx(
          ()=> CustomDropdownSingle(
        selectedItem: controller.selectBranch.value,
        hintText: 'Select Branch',
        width: DeviceType.isMobile(Get.context!) ? Get.width : null,
        items: controller.BranchList,
        isValidator: true,
        onChanged: controller.onBranchValueChanged,
      ),
    );
  }

  Widget BuildFilterBtn() {
    return AppIconButton(onPressed: (){
      Get.dialog(
        GenericDialogBox(
          headerText: 'Filter By Branch',
          content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: buildFilter()
          ),
          primaryButtonText: 'Apply',
          secondaryButtonText: 'Cancel',
          onPrimaryButtonPressed: () async {
            controller.getAllData(mainType: controller.currentSubMenu.value);
            Get.back();
          },
          onSecondaryButtonPressed: () {
            Get.back();
          },
          isLoading: controller.isLoading,
        ),
      );
      // AppUtils.appBottomSheet(Get.context!,buildFilter()
      //               .paddingSymmetric(horizontal: 10, vertical: 10));
    }, icon: CupertinoIcons.sort_down);
  }
}
