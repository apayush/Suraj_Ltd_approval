import 'package:flutter/material.dart';

class DeviceType {
  /// Checks if the device is a mobile
  static bool isMobile(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width < 600; // Generally less than 600px is considered mobile
  }

  /// Checks if the device is a tablet
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width >= 600 && size.width < 1024; // 600px to 1024px for tablets
  }

  /// Checks if the device is a desktop
  static bool isDesktop(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width >= 950; // Greater than or equal to 1024px for desktops
    // return size.width >= 1024; // Greater than or equal to 1024px for desktops
  }
// const ScreenBreakpoints(tablet: 600, desktop: 950, watch: 300),
}
