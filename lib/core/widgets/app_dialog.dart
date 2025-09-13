import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../constants/radius_utils.dart';
import '../utills/app_module_container.dart';
import 'common_widgets.dart';

class GenericDialogBox extends StatelessWidget {
  final String headerText;
  final Widget content;
  final String primaryButtonText;
  final VoidCallback? onPrimaryButtonPressed;
  final String secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;
  final bool isFullScreen;
  final bool isShowTopCloseButton;
  final RxBool? isLoading;

  const GenericDialogBox({
    super.key,
    required this.headerText,
    required this.content,
    this.primaryButtonText = '',
    this.onPrimaryButtonPressed,
    this.secondaryButtonText = '',
    this.onSecondaryButtonPressed,
    this.isFullScreen = false,
    this.isShowTopCloseButton = true,
    this.isLoading,
  });

  static const double _dialogPadding = 10.0;
  static const double _headerHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth >= 1024
        ? screenWidth * 0.4
        : screenWidth >= 768
        ? screenWidth * 0.6
        : screenWidth * 0.9;

    return AnimationConfiguration.synchronized(
      duration: const Duration(milliseconds: 350),
      child: ScaleAnimation(
        curve: Curves.easeOutBack,
        child: FadeInAnimation(
          child: Dialog(
            elevation: 12,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: RadiusUtils.borderRadiusForButtons,
            ),
            child: ClipRRect(
              borderRadius: RadiusUtils.borderRadiusForButtons,
              child: Container(
                width: isFullScreen ? screenWidth : dialogWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: RadiusUtils.borderRadiusForButtons,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context),
                      const Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(_dialogPadding),
                        child: content,
                      ),
                      _buildFooterButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: _headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: _dialogPadding),
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppText(
              headerText,
              style: TextStyles.medium(context),
            ),
          ),
          if (isShowTopCloseButton)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  CupertinoIcons.clear_thick,
                  size: 18.0,
                  color: Colors.grey,
                ),
                onPressed: Get.back,
              ),
            ),
        ],
      ),
    );
  }

  /// Footer
  Widget _buildFooterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        // horizontal: _dialogPadding,
        vertical: 15,
      ),
      child: Row(
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
              ?isLoading!=null? Obx(() {
            return Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: AppButton(
                onPressed: onPrimaryButtonPressed!,
                text: primaryButtonText,
                isLoading: isLoading?.value ?? false,
              ),
            );
          }):Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: AppButton(
              onPressed: onPrimaryButtonPressed!,
              text: primaryButtonText,
              isLoading: isLoading?.value ?? false,
            ),
          )
              : const SizedBox.shrink(),
        ],
      ),
      );
  }
}
