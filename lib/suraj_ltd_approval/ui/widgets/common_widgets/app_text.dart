import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Alignment alignment;
  final bool softWrap;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(this.text,
      {super.key,
        required this.style,
        this.alignment = Alignment.centerLeft,
        this.softWrap = false,
        this.maxLines,
        this.overflow});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: alignment,
        child: Text(
          text,
          style: style,
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
          // overflow: TextOverflow.visible, // Ensure overflow text is visible
        ));
  }
}

class TextStyles {
  static TextStyle extraSmall(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.extraSmall,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle small(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.small,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle normal(BuildContext context, {Color? textColor, double? size}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size ?? FontSizes.normal,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }


  static TextStyle normalBold(BuildContext context, {Color? textColor, FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.normal,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle medium(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.medium,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle tabStyle({Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: 15.0,
      color: textColor,
    );
  }

  static TextStyle mediumBold(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.medium,
      fontWeight: FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle large(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.large,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle largeBold(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.large,
      fontWeight: FontWeight.w600,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle extraLarge(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.extraLarge,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle huge(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.huge,
      color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle heading1(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.huge,
      fontWeight: FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.titleLarge?.color,
    );
  }

  static TextStyle heading2(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.extraLarge,
      fontWeight: FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.titleLarge?.color,
    );
  }

  static TextStyle heading3(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.large,
      fontWeight: FontWeight.bold,
      color: textColor ?? Theme.of(context).textTheme.titleLarge?.color,
    );
  }

  static TextStyle heading4(BuildContext context, {Color? textColor}) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.medium,
      fontWeight: FontWeight.w500,
      color: textColor ?? Theme.of(context).textTheme.titleLarge?.color,
    );
  }

  static TextStyle buttonTextStyle(BuildContext context, Color? color) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: FontSizes.small,
      color: color,
    );
  }

  static TextStyle appBarTitle(BuildContext context, {Color? textColor}) {
    return TextStyle(
        fontFamily: 'Poppins',
        fontSize: FontSizes.large,
        color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: FontWeight.bold);
  }
}

class FontSizes {
  static double extraSmall = 10.0;
  static double small = 12.0;
  static double normal = 13.0;
  static double medium = 15.0;
  static double large = 18.0;
  static double extraLarge = 20.0;
  static double huge = 24.0;
}
