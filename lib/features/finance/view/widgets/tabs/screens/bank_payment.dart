import 'package:flutter/material.dart';
import 'package:suraj_approval/core/widgets/common_widgets.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';

class BankPayment extends StatelessWidget {
  const BankPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText('Bank Payment', style: TextStyles.medium(context),alignment: Alignment.center,),
    );
  }
}
