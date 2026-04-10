import 'package:flutter/material.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final bool isInactive;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? color;
  final bool showBorder;

  const AppCard({
    super.key,
    required this.child,
    this.isInactive = false,
    this.margin,
    this.padding,
    this.onTap,
    this.borderRadius = 24,
    this.color,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color ??
            (isInactive
                ? (isDark ? Colors.grey.shade900 : Colors.grey.shade100)
                : (isDark ? AppTheme.darkCard : Colors.white)),
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.borderLightColor,
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isInactive ? null : onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}
