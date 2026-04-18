import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'message_type.dart';
import 'toast_widget.dart';

class Toast {
  Toast._();

  static final List<OverlayEntry?> _overlayEntries = List.empty(growable: true);

  static bool get isActive => _overlayEntries.isNotEmpty;
  static String? get currentMessage => isActive ? _currMsg : null;
  static String? _currMsg;

  /// Show a toast with an explicit [MessageType].
  static bool show(
    String? message, {
    MessageType messageType = MessageType.success,
    bool closeAllPrevious = true,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    bool isPersistent = false,
    bool showLoader = false,
    // Legacy support — kept so old callers still compile.
    @Deprecated('Use messageType instead') bool isPositive = true,
  }) {
    if (message == null) return false;
    if (Get.key.currentState != null) {
      _currMsg = message;
      final overlay = Get.key.currentState!.overlay;
      final entry = _createOverlayEntry(
        message,
        messageType: messageType,
        duration: duration,
        icon: icon,
        showLoader: showLoader,
        isPersistent: isPersistent,
      );
      if (closeAllPrevious) _closeAll();
      _overlayEntries.add(entry);
      overlay?.insert(entry);
      return true;
    }
    return false;
  }

  static OverlayEntry _createOverlayEntry(
    String message, {
    required MessageType messageType,
    required Duration duration,
    IconData? icon,
    bool isPersistent = false,
    bool showLoader = false,
  }) {
    return OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
          child: ToastWidget(
            message: message,
            messageType: messageType,
            iconData: icon,
            removeNotification: removeNotification,
            duration: duration,
            isPersistent: isPersistent,
            showLoader: showLoader,
          ),
        ),
      ),
    );
  }

  static void removeNotification() {
    if (_overlayEntries.isNotEmpty) {
      _overlayEntries.first?.remove();
      _overlayEntries.removeAt(0);
    }
  }

  static void _closeAll() {
    for (final entry in _overlayEntries) {
      entry?.remove();
    }
    _overlayEntries.clear();
  }
}
