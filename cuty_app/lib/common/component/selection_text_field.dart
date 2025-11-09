import 'package:flutter/material.dart';
import 'package:cuty_app/config/app_colors.dart';

class SelectionTextField extends StatelessWidget {
  final String value;
  final String hintText;
  final VoidCallback? onTap;
  final bool enabled;

  const SelectionTextField({
    super.key,
    required this.value,
    required this.hintText,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrayColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? hintText : value,
                style: TextStyle(
                  color: value.isEmpty
                      ? AppColors.textHint
                      : AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
