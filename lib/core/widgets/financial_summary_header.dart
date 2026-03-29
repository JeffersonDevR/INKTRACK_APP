import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/number_formatter.dart';

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

  String _formatDateRange() {
    if (startDate == null || endDate == null) return 'Hoy';
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.05),
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
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onDateTap != null || (actions != null && actions!.isNotEmpty))
                Row(
                  mainAxisSize: MainAxisSize.min,
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
                              color: AppTheme.primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 16,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDateRange(),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (actions != null) ...[
                      const SizedBox(width: 8),
                      ...actions!,
                    ],
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
                  label: label1 ?? 'Ingresos',
                  value: _formatValue(totalIngresos, isCurrency1),
                  color: AppTheme.successColor,
                  icon: icon1 ?? Icons.south_west_rounded,
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFF1F5F9)),
              Expanded(
                child: _StatItem(
                  label: label2 ?? 'Egresos',
                  value: _formatValue(totalEgresos, isCurrency2),
                  color: AppTheme.errorColor,
                  icon: icon2 ?? Icons.north_east_rounded,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label3 ?? 'Balance Neto',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
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
              if (isCurrency3)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        (balance >= 0
                                ? AppTheme.primaryColor
                                : AppTheme.errorColor)
                            .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    balance >= 0
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    size: 18,
                    color: balance >= 0
                        ? AppTheme.primaryColor
                        : AppTheme.errorColor,
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

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
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
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
