import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/constants/app_images.dart';

import '../../core/widgets/common_widgets.dart';
import '../utills/app_module_container.dart';

class PageNotfound extends StatelessWidget {
  const PageNotfound({super.key});

  @override
  Widget build(BuildContext context) {
    // Using LayoutBuilder to make the screen responsive
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText('Page Not Found', style: TextStyles.normal(context)),
        backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return _buildMobileLayout(context);
          } else {
            // Web layout
            return _buildWebLayout(context);
          }
        },
      ),
    );
  }

  // Mobile Layout for NotFoundPage
  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 100),
          const SizedBox(height: 20),
          AppText('404 - Page Not Found', style: TextStyles.heading4(context)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.offAllNamed('/'); // Navigate back to home
            },
            child: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }

  // Web Layout for NotFoundPage
  Widget _buildWebLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: AppText(
            "Sorry, we couldn't find that page…",
            alignment: Alignment.center,
            style: TextStyles.heading1(context, textColor: Colors.black),
          ),
        ),
        Expanded(
          flex: 8,
          child: AppImageAssets(
            AppImages.errorPage,
            height: 50.0,
            width: MediaQuery.of(context).size.width / 1.5,
            fit: BoxFit.fill, // or any fit you need
          ),
        ),
        Expanded(
          flex: 2,
          child: AppText(
            'But Dash is here to help! Maybe one of these will point you in the right direction?',
            alignment: Alignment.center,
            style: TextStyles.heading3(context, textColor: Colors.black),
          ),
        ),
      ],
    );
  }
}
