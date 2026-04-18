import 'package:flutter/material.dart';

/// Defines the intent of a toast message.
/// Controls the background colour and leading icon automatically.
enum MessageType {
  success,
  warning,
  error;

  Color get backgroundColor {
    switch (this) {
      case MessageType.success:
        return Colors.green.shade600;
      case MessageType.warning:
        return Colors.orange.shade700;
      case MessageType.error:
        return Colors.red.shade600;
    }
  }

  IconData get icon {
    switch (this) {
      case MessageType.success:
        return Icons.check_circle_outline_rounded;
      case MessageType.warning:
        return Icons.info_outline_rounded;
      case MessageType.error:
        return Icons.error_outline_rounded;
    }
  }
}
