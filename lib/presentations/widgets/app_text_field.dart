import 'package:dictionary_app/presentations/theme/theme_color.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.errorText = '',
    this.helpText,
    this.counterText = '',
    this.textStyle,
    this.borderColor,
    this.backgroundColor,
    this.prefixIcon,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText,
    this.enable = true,
    this.autoFocus = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.focusNode,
    this.controller,
    this.onChangedText,
    this.onChangedFocus,
    this.onSubmit,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.onEditingComplete,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textInputAction,
    this.suffixIcon,
    this.isUnderline = false,
    this.contentPadding,
    this.borderRadius,
    this.numSuffixIcon = 1,
    this.hintStyle,
    this.footer,
    this.height,
  }) : super(key: key);

  final String? labelText;
  final String? hintText;
  final String errorText;
  final String? helpText;
  final String? counterText;
  final TextStyle? textStyle;
  final Color? borderColor;
  final Color? backgroundColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? minLines;
  final int maxLines;
  final int? maxLength;
  final bool? obscureText;
  final bool enable;
  final bool autoFocus;
  final Function()? onTap;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChangedText;
  final Function(bool?)? onChangedFocus;
  final ValueChanged<String>? onSubmit;
  final bool readOnly;
  final TextAlign textAlign;
  final Function()? onEditingComplete;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextInputAction? textInputAction;
  final bool isUnderline;
  final EdgeInsets? contentPadding;
  final double? borderRadius;
  final num numSuffixIcon;
  final TextStyle? hintStyle;
  final Widget? footer;
  final double? height;

  @override
  AppTextFieldState createState() => AppTextFieldState();
}

class AppTextFieldState extends State<AppTextField> {
  dynamic _focusNode;

  @override
  void initState() {
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode;
    } else {
      _focusNode = FocusNode();
    }
    _focusNode.addListener(() {
      if (widget.onChangedFocus != null) {
        widget.onChangedFocus!(_focusNode.hasFocus);
      }
      if (mounted) {
        setState(() {});
      }
    });

    // _obscureText = widget.obscureText ?? false;
    super.initState();
  }

  onChanged(value) {
    if (widget.keyboardType == TextInputType.phone) {
      widget.controller!.selection = TextSelection(
          baseOffset: widget.controller!.text.length,
          extentOffset: widget.controller!.text.length);
    }
    if (widget.onChangedText != null) widget.onChangedText!(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.isUnderline
                ? null
                : BorderRadius.circular(widget.borderRadius ?? 12),
            border: widget.isUnderline
                ? Border(
                    bottom: BorderSide(
                      color: widget.borderColor ?? AppColors.stroke,
                      width: 1.0,
                    ),
                  )
                : Border.all(
                    color: widget.borderColor ?? AppColors.stroke, width: 1.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                textInputAction: widget.textInputAction,
                focusNode: _focusNode,
                style: widget.textStyle ?? ThemeText.bodyRegular,
                enableSuggestions: widget.enableSuggestions,
                autocorrect: widget.autocorrect,
                textCapitalization: widget.textCapitalization,
                onEditingComplete: widget.onEditingComplete,
                textAlign: widget.textAlign,
                keyboardType: widget.keyboardType,
                readOnly: widget.readOnly,
                inputFormatters: widget.inputFormatters,
                autofocus: widget.autoFocus,
                onTap: widget.onTap,
                cursorColor: AppColors.black,
                maxLength: widget.maxLength,
                maxLines: (widget.obscureText ?? false) ? 1 : null,
                controller: widget.controller,
                enabled: widget.enable,
                obscureText: widget.obscureText ?? false,
                decoration: InputDecoration(
                  counterText: widget.counterText,
                  labelText: widget.labelText,
                  labelStyle:
                      ThemeText.bodyRegular.copyWith(color: AppColors.white),
                  hintText: widget.hintText,
                  hintStyle:
                      widget.hintStyle ?? ThemeText.bodyRegular.grey0_5.s12,
                  helperText: widget.helpText,
                  contentPadding: widget.contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  prefixIcon: widget.prefixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 12,
                          ),
                          child: SizedBox(
                            //     width: 20,
                            //     height: 20,
                            child: widget.prefixIcon,
                          ),
                        )
                      : null,
                  prefixIconConstraints: widget.prefixIcon != null
                      ? const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 12,
                          ),
                          child: SizedBox(
                            width: 20 * widget.numSuffixIcon +
                                (widget.numSuffixIcon > 1
                                    ? (widget.numSuffixIcon - 1) * 16
                                    : 0),
                            height: 20,
                            child: widget.suffixIcon,
                          ),
                        )
                      : null,
                  suffixIconConstraints: widget.suffixIcon != null
                      ? const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        )
                      : null,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
                onSubmitted: widget.onSubmit,
              ),
              if (widget.footer != null) widget.footer!,
            ],
          ),
        ),

        //errorText element
        if (widget.errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              widget.errorText,
              style: ThemeText.errorText,
            ),
          )
      ],
    );
  }
}
