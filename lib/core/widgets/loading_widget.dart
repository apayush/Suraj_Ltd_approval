import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';


class LoaderWidget extends StatelessWidget {
  final controller;
  const LoaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => controller.isLoading.value
          ? const LoadingIndicator()
          : const SizedBox.shrink(),
    );
  }
}


class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWaveSpinner(
        color: const Color(0xFF007CB6),
        waveColor: Colors.blue.shade200,
        trackColor: Colors.blue.shade100,
        size: 60.0,
      ),
    );
  }
}
