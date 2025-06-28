import 'package:flutter/material.dart';

class RadiusUtils {
  // Define constants for different corner radii
  static const Radius smallRadius = Radius.circular(4.0);
  static const Radius mediumRadius = Radius.circular(4.0);
  static const Radius normalRadius = Radius.circular(12.0);
  static const Radius largeRadius = Radius.circular(16.0);
  static const Radius extraLargeRadius = Radius.circular(32.0);

  // If needed, create custom methods for specific shapes
  static BorderRadius borderRadiusSmall = const BorderRadius.all(smallRadius);
  static BorderRadius borderRadiusMedium = const BorderRadius.all(mediumRadius);
  static BorderRadius borderRadiusNormal = const BorderRadius.all(normalRadius);
  static BorderRadius borderRadiusLarge = const BorderRadius.all(largeRadius);
  static BorderRadius borderRadiusExtraLarge = const BorderRadius.all(extraLargeRadius);

  // static BorderRadius borderRadiusForButtons = const BorderRadius.all(normalRadius);
  static BorderRadius borderRadiusForButtons = const BorderRadius.all(Radius.circular(10.0));
  static BorderRadius borderRadiusForDataGrid = const BorderRadius.all(Radius.circular(10.0));

  // Specific corner radius
  static BorderRadius customRadius(double radius) => BorderRadius.circular(radius);
  static BorderRadius dataGridRadius() => BorderRadius.circular(16.0);
}