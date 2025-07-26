import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

class AppRadioButton extends StatelessWidget {
  final void Function(int?) onChanged;
  final int value;
  final int groupValue;

  const AppRadioButton({
    super.key,
    required this.onChanged,
    required this.value,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      onChanged: onChanged,
      groupValue: groupValue,
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.blue;
        }
        return Colors.grey;
      })
    );
  }
}