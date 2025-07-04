import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/common_text_field.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../controller/login_controller.dart';

class LoginTextFields extends GetView<LoginController> {
  const LoginTextFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextField(
          labelText: 'User Id',
          hintText: 'Enter your user id',
          keyboardType: TextInputType.emailAddress,
          controller: controller.userIdController,
        ),
        const SizedBox(height: 16.0),
        CommonTextField(
          labelText: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          controller: controller.passwordController,
        ),
        const SizedBox(height: 16.0),

        AppButton(onPressed: (){
          Get.offAllNamed(AppRouter.dashboardScreen);
        }, text:'Go To Dashboard')
      ],
    );
  }
}
