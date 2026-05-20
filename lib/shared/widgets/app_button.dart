import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? color;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? AppColors.primary;

    Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label, style: _textStyle(resolvedColor)),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: 18),
              ],
            ],
          );

    if (isFullWidth) {
      child = Center(child: child);
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: resolvedColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: resolvedColor.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: child,
          ),
        );

      case AppButtonVariant.secondary:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: resolvedColor.withOpacity(0.1),
              foregroundColor: resolvedColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: child,
          ),
        );

      case AppButtonVariant.outline:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: resolvedColor,
              side: BorderSide(color: resolvedColor),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: child,
          ),
        );

      case AppButtonVariant.ghost:
        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: resolvedColor,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: child,
          ),
        );
    }
  }

  TextStyle _textStyle(Color color) {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppTextStyles.buttonText.copyWith(color: Colors.white);
      default:
        return AppTextStyles.buttonText.copyWith(color: color);
    }
  }
}
