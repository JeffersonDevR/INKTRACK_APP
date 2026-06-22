import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../utils/number_formatter.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

class FinancialSummaryHeader extends StatelessWidget {
  final double totalIngresos;
  final double totalEgresos;
  final double balance;
  final String title;
  final VoidCallback? onDateTap;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Widget>? actions;
  final bool isCurrency1;
  final bool isCurrency2;
  final bool isCurrency3;
  final String? label1;
  final String? label2;
  final String? label3;
  final IconData? icon1;
  final IconData? icon2;
  final IconData? icon3;

  const FinancialSummaryHeader({
    super.key,
    required this.totalIngresos,
    required this.totalEgresos,
    required this.balance,
    this.title = 'Resumen\nFinanciero',
    this.onDateTap,
    this.startDate,
    this.endDate,
    this.actions,
    this.label1,
    this.label2,
    this.label3,
    this.icon1,
    this.icon2,
    this.icon3,
    this.isCurrency1 = true,
    this.isCurrency2 = true,
    this.isCurrency3 = true,
  });

  String _formatValue(double val, bool isCurrency) {
    if (isCurrency) {
      return NumberFormatter.formatCompact(val);
    }
    return NumberFormatter.formatNumber(val.toInt());
  }

  String _formatDateRange(BuildContext context) {
    if (startDate == null || endDate == null) return AppLocalizations.of(context)!.hoy;
    final df = DateFormat('dd MMM');
    if (startDate!.year == endDate!.year &&
        startDate!.month == endDate!.month &&
        startDate!.day == endDate!.day) {
      return df.format(startDate!);
    }
    return '${df.format(startDate!)} - ${df.format(endDate!)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.borderLightColor,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(
              alpha: isDark ? 0.15 : 0.05,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppTheme.darkTextPrimary
                              : AppTheme.textPrimary,
                          letterSpacing: -1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      balance >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 20,
                      color: balance >= 0
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                    ),
                  ],
                ),
              ),
              if (onDateTap != null || (actions != null && actions!.isNotEmpty))
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (onDateTap != null)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onDateTap,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 16,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDateRange(context),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (actions != null) ...actions!,
                  ],
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _StatItem(
                  label: label1 ?? l10n.ingresos,
                  value: _formatValue(totalIngresos, isCurrency1),
                  color: AppTheme.successColor,
                  icon: icon1 ?? Icons.south_west_rounded,
                  isDark: isDark,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppTheme.darkBorder : AppTheme.borderLightColor,
              ),
              Expanded(
                child: _StatItem(
                  label: label2 ?? l10n.egresos,
                  value: _formatValue(totalEgresos, isCurrency2),
                  color: AppTheme.errorColor,
                  icon: icon2 ?? Icons.north_east_rounded,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              height: 1,
              color: isDark ? AppTheme.darkBorder : AppTheme.borderLightColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label3 ?? l10n.balanceNeto,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatValue(balance, isCurrency3),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            color: balance >= 0 || !isCurrency3
                                ? AppTheme.successColor
                                : AppTheme.errorColor,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isDark;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 10, color: color),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            color: isDark ? AppTheme.darkTextPrimary : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
