import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/widgets/app_radio.dart';
import 'package:suraj_approval/features/auth/controller/login_controller.dart';

class LoginTypeSelection extends GetView<LoginController> {
  const LoginTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppRadioButton(
                  onChanged: controller.ipTypeChanged,
                  value: 1,
                  groupValue: controller.ipType.value,
                  title: 'Global',
                ),
              ),

              Expanded(
                child: AppRadioButton(
                  onChanged: controller.ipTypeChanged,
                  value: 2,
                  groupValue: controller.ipType.value,
                  title: 'Local',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
