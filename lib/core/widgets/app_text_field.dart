import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suraj_approval/core/utills/app_module_container.dart';

import '../constants/radius_utils.dart';
import 'common_widgets.dart';

class AppTextField extends StatelessWidget {
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
  final EdgeInsets? padding;
  final double? height;
  final bool readOnly;

  AppTextField({
    super.key,
    this.height = 45.0,
    this.width,
    this.floatingHint,
    this.initialValue,
    this.controller,
    this.onSaved,
    this.maxLines,
    this.minLines,
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
    this.padding,
    this.isSearchTextField = false,
    this.isValidator = false,
    this.isEmail = false,
    this.readOnly = false,
  });

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
      validator:
          isValidator
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: RadiusUtils.borderRadiusForButtons,
                    border: Border.all(
                      color:
                          state.hasError && controller!.text == ''
                              ? Colors.red
                              : Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: TextFormField(
                      maxLines: maxLines,
                      minLines: minLines,
                      enabled: enabled ?? true,
                      readOnly: readOnly,
                      validator: validator,
                      onTapOutside: (focusNode) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onTap: onTap,
                      onChanged: (value) {
                        onChanged?.call(
                          value,
                        ); // Calls onChanged if it is not null
                        isValidator
                            ? state.didChange(value)
                            : null; // Updates state if validation is enabled
                      },
                      // onChanged: onChanged,
                      // onSubmitted: onSubmitted,
                      autofillHints: autofillHints,
                      // onFieldSubmitted: onFieldSubmitted,
                      textCapitalization:
                          textCaps != null
                              ? textCaps!
                              : TextCapitalization.none,
                      autocorrect: autoCorrect ?? false,
                      decoration: InputDecoration(
                        labelText: floatingHint,
                        hintStyle: TextStyles.normal(
                          context,
                          textColor: Colors.grey,
                        ),
                        // contentPadding: EdgeInsets.zero,
                        isDense: true,
                        errorMaxLines: 2,
                        labelStyle: TextStyle(
                          color: hintColor,
                          fontSize: fontSize,
                        ),
                        icon: icon,
                        contentPadding:
                            padding ??
                            EdgeInsets.only(top: isSearchTextField ? 12.0 : 0),
                        // add padding to adjust text
                        prefixIcon:
                            isSearchTextField
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
                      // : validator,
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
                      inputFormatters:
                          inputFormatters ??
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
      },
    );
  }
}

class DropDownResponse {
  final String? value;
  final String? text;

  DropDownResponse({this.value, this.text});
}

class CustomDropdownSingle extends StatefulWidget {
  final double? width;
  final String hintText;
  DropDownResponse? selectedItem;
  final bool isEnabled;
  final bool isAddNewButton;
  final List<DropDownResponse>? items;
  final Future<List<DropDownResponse>> Function(String)? fetchData;
  final VoidCallback? onAddNewPressed;
  final String? validationMessage;
  final ValueChanged<DropDownResponse?>? onChanged;
  final bool isValidator;

  CustomDropdownSingle({
    super.key,
    this.width,
    required this.hintText,
    required this.selectedItem,
    this.isEnabled = true,
    this.isAddNewButton = false,
    this.items,
    this.fetchData,
    this.onAddNewPressed,
    this.validationMessage,
    this.onChanged,
    this.isValidator = false,
  });

  @override
  State<CustomDropdownSingle> createState() => _CustomDropdownSingleState();
}

class _CustomDropdownSingleState extends State<CustomDropdownSingle> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.selectedItem?.text ?? '');
  }

  @override
  void didUpdateWidget(covariant CustomDropdownSingle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem ||
        oldWidget.items != widget.items) {
      DropDownResponse? selected = widget.selectedItem;
      if (selected != null && (selected.text == null || selected.text!.isEmpty)) {
        final match = widget.items?.firstWhere(
              (e) => e.value == selected?.value,
          orElse: () => selected!,
        );
        selected = match;
      }
      controller.text = selected?.text ?? '';
      if (selected != widget.selectedItem) {
        widget.selectedItem = selected;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double adjustedWidth = widget.width ?? screenWidth;
    if (screenWidth >= 600 && screenWidth < 1024) {
      adjustedWidth = screenWidth * 0.75;
    } else if (screenWidth >= 1024) {
      adjustedWidth = 350.0;
    }

    return FormField<DropDownResponse>(
      initialValue: widget.selectedItem,
      validator: widget.isValidator
          ? (value) {
        if (widget.selectedItem != null) return null;
        if (value == null) {
          return widget.hintText;
        }
        return null;
      }
          : null,
      builder: (state) {
        if (state.value != widget.selectedItem) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.didChange(widget.selectedItem);
          });
        }
        return SizedBox(
          width: widget.width ?? adjustedWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 45.0,
                width: widget.width ?? adjustedWidth,
                child: _buildDropdownField(context, state),
              ),
              if (state.hasError && widget.selectedItem == null)
                _buildErrorText(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdownField(
      BuildContext context,
      FormFieldState<DropDownResponse> state,
      ) {
    return Container(
      height: 45.0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: state.hasError && widget.selectedItem == null
              ? Colors.red
              : Colors.grey,
          width: 0.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DropDownResponse>(
          value: widget.selectedItem,
          isExpanded: true,
          isDense: true,
          hint: Text(
            widget.hintText,
            style: TextStyle(color: Colors.grey),
          ),
          items: widget.items?.map((DropDownResponse item) {
            return DropdownMenuItem<DropDownResponse>(
              value: item,
              child: Text(item.text ?? ''),
            );
          }).toList(),
          onChanged: widget.isEnabled
              ? (DropDownResponse? newValue) {
            setState(() {
              widget.selectedItem = newValue;
            });
            state.didChange(newValue);
            widget.onChanged?.call(newValue);
          }
              : null,
        ),
      ),
    );
  }

  Widget _buildErrorText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 4.0),
      child: Text(
        widget.validationMessage ?? widget.hintText,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}