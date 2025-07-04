import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../../../core/widgets/app_text_field.dart';

class CashPayment extends StatelessWidget {
  const CashPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSearchFieldRow(context),
      ],
    );
  }
}


Widget buildSearchFieldRow(BuildContext context) {
  final screenType = getDeviceType(MediaQuery.of(context).size);
  return Row(
    children: [
      if(screenType == DeviceScreenType.mobile)
        Expanded(child: buildSearchTextField())
      else
        buildSearchTextField(),
    ],
  );
}

Widget buildSearchTextField() {
  return AppTextField(
    hint: 'Search',
    // controller: controller.searchController,
    // onChanged: (value) {
    //   controller.filterData(value);
    // },
  );
}