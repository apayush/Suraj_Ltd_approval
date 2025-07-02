import 'package:flutter/material.dart';
import 'package:suraj_approval/core/constants/app_images.dart';

import 'common_widgets.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return AppImageAssets(
      AppImages.noDataFound,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      fit: BoxFit.contain, // or any fit you need
    );
  }
}
