import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suraj_approval/core/theme/app_colors.dart';

class AppRadioButton extends StatelessWidget {
  final void Function(int?) onChanged;
  final int value;
  final int groupValue;
  final String title;

  const AppRadioButton({
    super.key,
    required this.onChanged,
    required this.value,
    required this.groupValue,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return RadioListTile(
      value: value,
      onChanged: onChanged,
      groupValue: groupValue,
      title:Text(title) ,
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.blue;
        }
        return Colors.grey;
      }),
    );
  }
}
