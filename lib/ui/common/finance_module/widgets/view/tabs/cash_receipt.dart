import 'package:flutter/material.dart';

import '../../../../../../core/widgets/app_text_field.dart';

class CashReceipt extends StatelessWidget {
  const CashReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            buildSearchTextField(),
          ],
        ),
      ],
    );
  }
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