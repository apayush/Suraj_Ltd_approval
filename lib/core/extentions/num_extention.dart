import 'package:flutter/material.dart';

extension NumberExtension on num {
  Widget get heightGap => SizedBox(height: toDouble());
  Widget get widthGap => SizedBox(width: toDouble());
}
