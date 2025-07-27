import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:suraj_approval/core/constants/app_strings.dart';
import 'package:suraj_approval/core/extentions/num_extention.dart';
import 'package:suraj_approval/core/widgets/app_text_field.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/features/finance/controller/finance_controller.dart';

class FinanceSearchAndRefreshWidget extends GetView<FinanceController> {
  const FinanceSearchAndRefreshWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenType = getDeviceType(MediaQuery.of(context).size);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (screenType == DeviceScreenType.mobile)
          Expanded(child: buildSearchTextField())
        else
          buildSearchTextField(),
        10.widthGap,
        buildClearFilterButton(),
      ],
    );
  }

  Widget buildSearchTextField() {
    return AppTextField(
      hint: 'Search',
      controller: controller.searchController,
      onChanged: (value) {
        controller.filterData(value);
      },
    );
  }

  Widget buildClearFilterButton() {
    return AppIconButton(
      tooltip: AppStrings.reset,
      onPressed: controller.resetFilters,
      icon: CupertinoIcons.arrow_clockwise,
    );
  }
}
