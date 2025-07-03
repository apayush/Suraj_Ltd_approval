import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utills/app_module_container.dart';
import '../constants/radius_utils.dart';
import '../theme/app_colors.dart';
import 'common_widgets.dart';

class GenericDialogBox extends StatelessWidget {
  final String headerText;
  final Widget content;
  final String primaryButtonText;
  final VoidCallback? onPrimaryButtonPressed;
  final String secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;
  final bool isFullScreen;

  const GenericDialogBox({
    super.key,
    required this.headerText,
    required this.content,
    this.primaryButtonText = '',
    this.onPrimaryButtonPressed,
    this.secondaryButtonText = '',
    this.onSecondaryButtonPressed,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: RadiusUtils.borderRadiusForButtons,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;

          // Adjust dialog width based on screen size
          final dialogWidth =
              screenWidth >= 1024
                  ? screenWidth *
                      0.4 // Web/Desktop
                  : screenWidth >= 768
                  ? screenWidth *
                      0.6 // Tablet
                  : screenWidth * 0.9; // Mobile

          return ClipRRect(
            borderRadius: RadiusUtils.borderRadiusForButtons,
            child: Container(
              width: isFullScreen ? screenWidth : dialogWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: RadiusUtils.borderRadiusForButtons,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      height: 45.0,
                      // padding: const EdgeInsets.all(12.0),
                      color: AppColors.blue,
                      child: Stack(
                        children: [
                          AppText(
                            headerText,
                            alignment: Alignment.center,
                            style: TextStyles.medium(
                              context,
                              textColor: Colors.white,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: Get.back,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dynamic Content
                    Padding(padding: const EdgeInsets.all(8.0), child: content),

                    const SizedBox(height: 20),

                    // Buttons at the bottom
                    Row(
                      mainAxisAlignment:
                          secondaryButtonText != ''
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Secondary Button
                        secondaryButtonText != '' &&
                                onSecondaryButtonPressed != null
                            ? Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: AppButton(
                                onPressed: onSecondaryButtonPressed!,
                                text: secondaryButtonText,
                                isCancelButton: true,
                              ),
                            )
                            : const SizedBox.shrink(),

                        // Primary Button
                        onPrimaryButtonPressed != null
                            ? Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: AppButton(
                                onPressed: onPrimaryButtonPressed!,
                                text: primaryButtonText,
                              ),
                            )
                            : const SizedBox.shrink(),
                      ],
                    ),

                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
