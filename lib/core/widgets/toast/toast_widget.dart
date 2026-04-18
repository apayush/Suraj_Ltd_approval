import 'dart:async';
import 'package:flutter/material.dart';
import 'message_type.dart';

class ToastWidget extends StatefulWidget {
  const ToastWidget({
    required this.message,
    required this.removeNotification,
    this.messageType = MessageType.success,
    this.iconData,
    super.key,
    required this.duration,
    this.isPersistent = false,
    this.showLoader = false,
  });

  final String message;
  final MessageType messageType;
  final Duration duration;

  /// Override the automatic icon from [messageType] if needed.
  final IconData? iconData;
  final bool isPersistent;
  final bool showLoader;
  final VoidCallback removeNotification;

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    _startAnimation();
    super.initState();
    if (!widget.isPersistent) {
      Future.delayed(widget.duration, () {
        if (mounted) {
          _controller.reverse().then((_) => widget.removeNotification());
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.fastLinearToSlowEaseIn),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.fastLinearToSlowEaseIn),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.messageType.backgroundColor;
    final icon = widget.iconData ?? widget.messageType.icon;

    return Material(
      type: MaterialType.transparency,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: bgColor,
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Icon ─────────────────────────────────────────────────
                    if (widget.showLoader)
                      const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          strokeCap: StrokeCap.round,
                          color: Colors.white,
                        ),
                      )
                    else
                      Icon(icon, color: Colors.white, size: 22),
                    const SizedBox(width: 12),
                    // ── Message ───────────────────────────────────────────────
                    Flexible(
                      child: Text(
                        widget.message,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
