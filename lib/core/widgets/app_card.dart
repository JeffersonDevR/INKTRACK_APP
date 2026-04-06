import 'package:flutter/material.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final bool isInactive;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.isInactive = false,
    this.margin,
    this.padding,
    this.onTap,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      color: isInactive
          ? (isDark ? Colors.grey.shade800 : Colors.grey.shade100)
          : (isDark ? AppTheme.darkCard : null),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: isDark ? AppTheme.darkBorder : Colors.transparent,
        ),
      ),
      child: onTap != null
          ? InkWell(
              onTap: isInactive ? null : onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: _buildContent(isDark),
            )
          : _buildContent(isDark),
    );
  }

  Widget _buildContent(bool isDark) {
    return Padding(padding: padding ?? const EdgeInsets.all(16), child: child);
  }
}
