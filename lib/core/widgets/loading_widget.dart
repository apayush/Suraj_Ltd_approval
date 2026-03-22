import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

class LoaderWidget extends StatelessWidget {
  final controller;
  const LoaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Stack(
          children: [
            // Blocks all gestures
            const ModalBarrier(
              dismissible: false,
              color: Colors.transparent, // optional background
            ),
            const LoadingIndicator(),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }
}

class LoadingIndicator extends StatelessWidget {
  final double size;
  const LoadingIndicator({super.key, this.size = 60.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWaveSpinner(
        color: const Color(0xFF007CB6),
        waveColor: AppColors.blue200,
        trackColor: AppColors.blue100,
        size: size,
      ),
    );
  }
}
