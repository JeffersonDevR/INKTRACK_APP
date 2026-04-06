import 'package:flutter/material.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

enum BadgeType { inactive, fiado, warning, success, error, info, primary }

class AppBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final double? fontSize;

  const AppBadge({
    super.key,
    required this.label,
    this.type = BadgeType.inactive,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getColors(isDark);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize != null ? fontSize! * 0.6 : 6,
        vertical: fontSize != null ? fontSize! * 0.2 : 2,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize ?? 10,
          fontWeight: FontWeight.w900,
          color: colors.text,
        ),
      ),
    );
  }

  _BadgeColors _getColors(bool isDark) {
    switch (type) {
      case BadgeType.inactive:
        return _BadgeColors(
          background: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
          text: Colors.white,
        );
      case BadgeType.fiado:
        return _BadgeColors(
          background: AppTheme.errorColor.withValues(alpha: 0.15),
          text: AppTheme.errorColor,
        );
      case BadgeType.warning:
        return _BadgeColors(
          background: AppTheme.warningColor.withValues(alpha: 0.15),
          text: AppTheme.warningColor,
        );
      case BadgeType.success:
        return _BadgeColors(
          background: AppTheme.successColor.withValues(alpha: 0.15),
          text: AppTheme.successColor,
        );
      case BadgeType.error:
        return _BadgeColors(
          background: AppTheme.errorColor.withValues(alpha: 0.15),
          text: AppTheme.errorColor,
        );
      case BadgeType.info:
        return _BadgeColors(
          background: AppTheme.infoColor.withValues(alpha: 0.15),
          text: AppTheme.infoColor,
        );
      case BadgeType.primary:
        return _BadgeColors(
          background: AppTheme.primaryColor.withValues(alpha: 0.15),
          text: AppTheme.primaryColor,
        );
    }
  }
}

class _BadgeColors {
  final Color background;
  final Color text;

  _BadgeColors({required this.background, required this.text});
}
