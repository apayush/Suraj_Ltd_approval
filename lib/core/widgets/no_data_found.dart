import 'package:flutter/material.dart';

import 'common_widgets.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return AppImageAssets(
      'assets/images/no_data.png',
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      fit: BoxFit.contain, // or any fit you need
    );
  }
}
