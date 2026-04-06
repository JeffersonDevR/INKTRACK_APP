import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isLarge;
  final String? subtitle;
  final bool useSolidBackground;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.isLarge = false,
    this.subtitle,
    this.useSolidBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: isLarge ? 4 : 2,
      shadowColor: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDark
              ? AppTheme.darkBorder
              : (useSolidBackground
                    ? Colors.transparent
                    : const Color(0xFFF1F5F9)),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: useSolidBackground
              ? color
              : (isDark ? AppTheme.darkCard : Colors.white),
          gradient: !useSolidBackground
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark ? AppTheme.darkCard : Colors.white,
                    isDark
                        ? color.withValues(alpha: 0.1)
                        : color.withValues(alpha: isLarge ? 0.05 : 0.02),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.8)],
                ),
          boxShadow: useSolidBackground
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.all(isLarge ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: useSolidBackground
                        ? Colors.white.withValues(alpha: 0.2)
                        : color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: useSolidBackground ? Colors.white : color,
                    size: isLarge ? 24 : 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: useSolidBackground
                              ? Colors.white.withValues(alpha: 0.9)
                              : (isDark
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.textSecondary),
                          letterSpacing: 0.3,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style:
                    (isLarge
                            ? Theme.of(context).textTheme.headlineSmall
                            : Theme.of(context).textTheme.titleLarge)
                        ?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: useSolidBackground
                              ? Colors.white
                              : (isLarge
                                    ? color
                                    : (isDark
                                          ? AppTheme.darkTextPrimary
                                          : AppTheme.textPrimary)),
                          letterSpacing: -0.8,
                        ),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: useSolidBackground
                      ? Colors.white.withValues(alpha: 0.7)
                      : (isDark
                            ? AppTheme.darkTextTertiary
                            : AppTheme.textSecondary),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
