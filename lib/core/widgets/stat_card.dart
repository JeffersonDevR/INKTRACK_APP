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
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: useSolidBackground
            ? color
            : (isDark ? AppTheme.darkCard : Colors.white),
        boxShadow: [
          BoxShadow(
            color: useSolidBackground
                ? color.withValues(alpha: 0.3)
                : (isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.08)),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: !useSolidBackground
            ? Border.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.borderLightColor,
                width: 1,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            if (!useSolidBackground)
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  icon,
                  size: 100,
                  color: color.withValues(alpha: 0.03),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(isLarge ? 24 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: useSolidBackground
                              ? Colors.white.withValues(alpha: 0.2)
                              : color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          icon,
                          color: useSolidBackground ? Colors.white : color,
                          size: isLarge ? 24 : 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          label,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: useSolidBackground
                                ? Colors.white.withValues(alpha: 0.9)
                                : (isDark
                                    ? AppTheme.darkTextSecondary
                                    : AppTheme.textSecondary),
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: (isLarge
                              ? theme.textTheme.displaySmall
                              : theme.textTheme.headlineMedium)
                          ?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: useSolidBackground
                            ? Colors.white
                            : (isDark
                                ? AppTheme.darkTextPrimary
                                : AppTheme.textPrimary),
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: useSolidBackground
                            ? Colors.white.withValues(alpha: 0.15)
                            : color.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: useSolidBackground
                              ? Colors.white
                              : color,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
