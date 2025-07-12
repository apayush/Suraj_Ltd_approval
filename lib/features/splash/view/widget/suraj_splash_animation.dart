import 'package:flutter/material.dart';
import 'package:suraj_approval/core/constants/app_images.dart';

class SurajSplashAnimation extends StatefulWidget {
  final VoidCallback? onAnimationComplete;

  const SurajSplashAnimation({super.key, this.onAnimationComplete});

  @override
  State<SurajSplashAnimation> createState() => _SurajSplashAnimationState();
}

class _SurajSplashAnimationState extends State<SurajSplashAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward().whenComplete(() {
      if (widget.onAnimationComplete != null) {
        Future.delayed(const Duration(milliseconds: 500), widget.onAnimationComplete!);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset(
            AppImages.surajPvtLogo,
            width: 180,
            height: 180,
          ),
        ),
      ),
    );
  }
}
