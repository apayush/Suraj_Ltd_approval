import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utills/app_module_container.dart';
import '../constants/radius_utils.dart';
import 'common_widgets.dart';

class AppTextField extends StatelessWidget {
  final double? height;
  final double? width;
  final String? floatingHint;
  final String? hint;
  final String? errorText;
  final String? initialValue;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final FormFieldValidator<String>? validator;
  final Color? underlineColor;
  final Color? hintColor;
  final Color? textColor;
  final TextInputType? keyboardType;
  final bool? showPasswordType;
  final bool? enabled;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLength;
  final bool? autoFocus;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Color? cursorColor;
  final Color? disabledColor;
  final int? maxLines;
  final int? minLines;
  // InputBorder? inputBorder;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final bool? isRoundedBorer;
  final bool? autovalidate;
  final double? contentPadding;
  final TextInputAction? textInputAction;
  final Widget? icon;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? suffixText;
  final TextStyle? suffixStyle;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final void Function()? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCaps;
  final bool? autoCorrect;
  final Iterable<String>? autofillHints;
  final bool isSearchTextField;
  final bool isValidator;
  final bool isEmail;

  AppTextField(
      {super.key,
        this.height = 45.0,
        this.width,
        this.floatingHint,
        this.initialValue,
        this.contentPadding = 5.0,
        this.controller,
        this.onSaved,
        this.maxLines = 1,
        this.minLines = 1,
        this.validator,
        this.hintColor,
        this.textColor,
        this.underlineColor,
        this.keyboardType,
        this.showPasswordType = false,
        this.enabled = true,
        this.onTap,
        this.autoFocus = false,
        this.fontSize = 14.0,
        this.maxLength,
        this.textAlign = TextAlign.start,
        this.focusNode,
        this.cursorColor,
        this.hint,
        this.errorText,
        this.fontWeight,
        this.isRoundedBorer = false,
        this.borderColor,
        this.borderRadius = 10,
        this.borderWidth = 1.0,
        this.autovalidate = false,
        this.disabledColor,
        this.textInputAction,
        this.icon,
        this.suffixIcon,
        this.prefixIcon,
        this.suffixText,
        this.suffixStyle,
        this.prefixText,
        this.prefixStyle,
        this.onChanged,
        this.onSubmitted,
        this.onFieldSubmitted,
        this.decoration = const InputDecoration(),
        this.onEditingComplete,
        this.textCaps,
        this.autoCorrect,
        this.inputFormatters,
        this.autofillHints,
        this.isSearchTextField = false,
        this.isValidator = false,
        this.isEmail = false});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double adjustedWidth = width ?? screenWidth;
    if (screenWidth >= 600 && screenWidth < 1024) {
      adjustedWidth = screenWidth * 0.75;
    } else if (screenWidth >= 1024) {
      adjustedWidth = 350.0;
    }

    return FormField<String>(
        validator: isValidator
            ? (value) {
          if (value == null || value.isEmpty) {
            return hint;
          }
          if (isEmail &&
              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
            return 'Enter a valid email address';
          }
          return null;
        }
            : null,
        initialValue: controller != null ? controller!.text : '',
        builder: (FormFieldState<String> state) {
          return SizedBox(
            width: width ?? adjustedWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: height,
                  width: width ?? adjustedWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: RadiusUtils.borderRadiusForButtons,
                      border: Border.all(
                        color: state.hasError && controller!.text == ''
                            ? Colors.red
                            : Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: TextField(
                        maxLines: maxLines,
                        minLines: minLines,
                        enabled: enabled ?? true,
                        onTapOutside: (focusNode) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onTap: onTap,
                        onChanged: (value) {
                          onChanged?.call(
                              value); // Calls onChanged if it is not null
                          isValidator
                              ? state.didChange(value)
                              : null; // Updates state if validation is enabled
                        },
                        // onChanged: onChanged,
                        onSubmitted: onSubmitted,
                        autofillHints: autofillHints,
                        // onFieldSubmitted: onFieldSubmitted,
                        textCapitalization: textCaps != null
                            ? textCaps!
                            : TextCapitalization.none,
                        autocorrect: autoCorrect ?? false,
                        decoration: InputDecoration(
                          labelText: floatingHint,
                          hintStyle: TextStyles.normal(context,
                              textColor: Colors.grey),
                          // contentPadding: EdgeInsets.zero,
                          isDense: true,
                          errorMaxLines: 2,
                          labelStyle: TextStyle(
                            color: hintColor,
                            fontSize: fontSize,
                          ),
                          icon: icon,
                          contentPadding: EdgeInsets.only(
                              top: isSearchTextField ? 12.0 : 0),
                          // add padding to adjust text
                          prefixIcon: isSearchTextField
                              ? const Icon(CupertinoIcons.search)
                              : null,
                          // suffixIcon: suffixIcon,
                          suffix: suffixIcon,
                          suffixText: suffixText,
                          suffixStyle: suffixStyle,
                          prefixText: prefixText,
                          prefixStyle: prefixStyle,
                          hintText: hint,
                          errorText: errorText,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          counterText: '',
                        ),
                        style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                          fontWeight: FontWeight.normal,
                        ),
                        // onSaved: onSaved,
                        // validator: validator,
                        keyboardType: keyboardType,
                        obscureText: showPasswordType ?? false,
                        controller: controller,
                        textInputAction: textInputAction ?? TextInputAction.next,
                        autofocus: autoFocus ?? false,
                        textAlign: textAlign ?? TextAlign.start,
                        focusNode: focusNode,
                        maxLength: maxLength,
                        // initialValue: initialValue,
                        onEditingComplete: onEditingComplete,
                        inputFormatters: inputFormatters ??
                            (maxLength != null
                                ? [LengthLimitingTextInputFormatter(maxLength!)]
                                : null),
                      ),
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: AppText(
                      state.errorText ?? '',
                      style: TextStyles.normal(context, textColor: Colors.red),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
