import 'package:flutter/material.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

enum AppTextStyle {
  heading,
  title,
  body,
  label,
  caption,
  primary,
  secondary,
  tertiary,
  success,
  error,
  warning,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double? fontSize;

  const AppText(
    this.text, {
    super.key,
    this.style = AppTextStyle.body,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.fontWeight,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = _getStyle(context, isDark);

    return Text(
      text,
      style: textStyle.copyWith(fontWeight: fontWeight, fontSize: fontSize),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }

  TextStyle _getStyle(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme;

    switch (style) {
      case AppTextStyle.heading:
        return (isDark ? baseStyle.headlineMedium : baseStyle.headlineMedium)
                ?.copyWith(
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.textPrimary,
                ) ??
            const TextStyle();
      case AppTextStyle.title:
        return (isDark ? baseStyle.titleLarge : baseStyle.titleLarge)?.copyWith(
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ) ??
            const TextStyle();
      case AppTextStyle.body:
        return (isDark ? baseStyle.bodyLarge : baseStyle.bodyLarge)?.copyWith(
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            ) ??
            const TextStyle();
      case AppTextStyle.label:
        return (isDark ? baseStyle.labelLarge : baseStyle.labelLarge)?.copyWith(
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.textSecondary,
            ) ??
            const TextStyle();
      case AppTextStyle.caption:
        return (isDark ? baseStyle.bodySmall : baseStyle.bodySmall)?.copyWith(
              color: isDark ? AppTheme.darkTextTertiary : AppTheme.textTertiary,
            ) ??
            const TextStyle();
      case AppTextStyle.primary:
        return (isDark ? baseStyle.bodyLarge : baseStyle.bodyLarge)?.copyWith(
              color: AppTheme.primaryColor,
            ) ??
            const TextStyle();
      case AppTextStyle.secondary:
        return (isDark ? baseStyle.bodyLarge : baseStyle.bodyLarge)?.copyWith(
              color: AppTheme.secondaryColor,
            ) ??
            const TextStyle();
      case AppTextStyle.tertiary:
        return (isDark ? baseStyle.bodyLarge : baseStyle.bodyLarge)?.copyWith(
              color: AppTheme.accentColor,
            ) ??
            const TextStyle();
      case AppTextStyle.success:
        return (isDark ? baseStyle.bodyLarge : baseStyle.bodyLarge)?.copyWith(
              color: AppTheme.successColor,
            ) ??
            const TextStyle();
      case AppTextStyle.error:
        return (isDark ? baseStyle.bodyLarge : baseStyle.bodyLarge)?.copyWith(
              color: AppTheme.errorColor,
            ) ??
            const TextStyle();
      case AppTextStyle.warning:
        return (isDark ? baseStyle.bodyLarge : baseStyle.bodyLarge)?.copyWith(
              color: AppTheme.warningColor,
            ) ??
            const TextStyle();
    }
  }
}
