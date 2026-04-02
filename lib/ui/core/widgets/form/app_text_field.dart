import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/input_theme.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum InputState { empty, filled, error }

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.hintText,
    super.key,
    this.prefixIcon,
    this.autoCorrect = true,
    this.suffix,
    this.suffixIcon,
    this.isLoading,
    this.isReadOnly = false,
    this.inputAction,
    this.inputFormatters,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onClear,
    this.validator,
    this.isAmount = false,
    this.isPassword = false,
    this.maxLines = 1,
  });

  final String hintText;
  final String? prefixIcon;
  final String? suffixIcon;
  final Widget? suffix;
  final bool isReadOnly;
  final bool autoCorrect;
  final bool? isLoading;
  final bool isPassword;
  final bool isAmount;
  final TextInputType keyboardType;
  final TextInputAction? inputAction;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasText = false;
  bool _showText = true;
  String? _errorText;
  InputState _inputState = InputState.empty;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _showText = !widget.isPassword;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
      if (_hasText && widget.validator != null) {
        _errorText = widget.validator!(_controller.text);
        final isValid = _errorText == null;
        _inputState = isValid ? InputState.filled : InputState.error;
      } else {
        _inputState = _hasText ? InputState.filled : InputState.empty;
      }
    });
    widget.onChanged?.call(_controller.text);
  }

  Widget? _buildSuffix(Color color) {
    final isPassword = widget.isPassword;
    if (widget.suffix != null) {
      return widget.suffix!;
    }

    if (isPassword) {
      return Padding(
        padding: EdgeInsets.only(right: 20.w, left: 12.w),
        child: GestureDetector(
          onTap: () => setState(() => _showText = !_showText),
          child: Text(
            _showText ? 'Hide' : 'Show',
            style: AppTextStyles.text.sm.semibold.copyWith(
              color: color,
            ),
          ),
        ),
      );
    }
    if (_focusNode.hasFocus && _hasText) {
      return Padding(
        padding: EdgeInsets.only(right: 20.w, left: 12.w),
        child: Semantics(
          label: 'Clear input field',
          child: GestureDetector(
            onTap: () {
              _controller.clear();
              widget.onClear?.call();
            },
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: _inputState == InputState.error
                    ? AppColors.error.shade300
                    : AppColors.neutrals.shade900,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return Padding(
        padding: EdgeInsets.only(right: 20.w, left: 12.w),
        child: AppImage(
          imageUrl: widget.suffixIcon!,
          height: 24.h,
          width: 24.w,
          color: color,
        ),
      );
    }
    return null;
  }

  Widget? _buildPrefix(Color color) {
    final prefixIcon = widget.prefixIcon;
    if (prefixIcon != null && prefixIcon.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: 20.w, right: 12.w),
        child: AppImage(
          imageUrl: prefixIcon,
          color: color,
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final appInputTheme = Theme.of(context).appInputTheme;
    final inputTheme = Theme.of(context).inputDecorationTheme;
    final filledColor = switch (_inputState) {
      InputState.empty => appInputTheme.emptyBackground,
      InputState.filled => appInputTheme.filledBackground,
      InputState.error => appInputTheme.invalidBackground,
    };
    final amountFormatter = [
      FilteringTextInputFormatter.allow(
        RegExp(r'^[1-9][0-9]*$|^$'),
      ),
    ];
    final prefixSuffixColor = switch (_inputState) {
      InputState.empty => inputTheme.prefixIconColor ?? color.primary,
      _ => color.primary,
    };
    return Column(
      crossAxisAlignment: .start,
      children: [
        TextFormField(
          autovalidateMode: .onUserInteraction,
          controller: _controller,
          style: AppTextStyles.text.md.semibold.copyWith(
            color: color.onSurface,
          ),
          cursorColor: color.primary,
          obscureText: !_showText,
          readOnly: widget.isReadOnly,
          autocorrect: widget.autoCorrect,
          maxLines: widget.maxLines,
          onFieldSubmitted: (value) {
            if (widget.inputAction == TextInputAction.next) {
              _focusNode.nextFocus();
            } else {
              _focusNode.unfocus();
            }
          },
          keyboardType: widget.keyboardType,
          inputFormatters: widget.isAmount
              ? amountFormatter
              : widget.inputFormatters,
          textInputAction: widget.inputAction,
          onChanged: widget.onChanged,
          validator: widget.validator,
          showCursor: !widget.isReadOnly,
          cursorErrorColor: color.error,
          decoration: InputDecoration(
            filled: true,
            fillColor: filledColor,
            hintText: widget.hintText,
            prefixIconConstraints: inputTheme.prefixIconConstraints,
            suffixIconConstraints: inputTheme.suffixIconConstraints,
            prefixIcon: _buildPrefix(prefixSuffixColor),
            suffixIcon: _buildSuffix(prefixSuffixColor),
            border: inputTheme.border,
            enabledBorder: inputTheme.enabledBorder,
            focusedBorder: inputTheme.focusedBorder,
            errorBorder: _inputState == InputState.error
                ? inputTheme.errorBorder
                : inputTheme.enabledBorder,
            focusedErrorBorder: _inputState == InputState.error
                ? inputTheme.errorBorder
                : inputTheme.enabledBorder,
            contentPadding: inputTheme.contentPadding,
            hintStyle: inputTheme.hintStyle,
            errorStyle: const TextStyle(
              fontSize: 0,
            ),
          ),
        ),
        if (_hasText && _errorText != null) ...[
          4.verticalSpace,
          Text(
            _errorText!,
            style: inputTheme.errorStyle,
          ),
        ],
      ],
    );
  }
}
