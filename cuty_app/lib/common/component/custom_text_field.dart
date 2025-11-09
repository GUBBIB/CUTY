import 'package:flutter/material.dart';
import 'package:cuty_app/config/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.decoration,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14.0,
      ),
      maxLines: maxLines,
      maxLength: maxLength,
      textAlignVertical: TextAlignVertical.top,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textHint,
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: AppColors.backgroundGrayColor,
            contentPadding: const EdgeInsets.all(12.0), // 추가
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon,
          ),
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
    );
  }
}
