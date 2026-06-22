import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

class TrendChart extends StatelessWidget {
  final List<Movimiento> movimientos;
  final int days;

  const TrendChart({
    super.key,
    required this.movimientos,
    this.days = 7,
  });

  @override
  Widget build(BuildContext context) {
    final data = _processData();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.borderLightColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.tendenciaUltimos(days),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildLegend(context),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(data),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark ? AppTheme.darkBorder : AppTheme.borderLightColor,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= data.length || value.toInt() < 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            data[value.toInt()].label,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _calculateInterval(data),
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          NumberFormat.compact().format(value),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY: 0,
                maxY: _calculateMaxY(data),
                lineBarsData: [
                  _createLineSeries(data, isIngreso: true),
                  _createLineSeries(data, isIngreso: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _legendItem(context, l10n.ingresos, AppTheme.tertiaryColor),
        const SizedBox(width: 12),
        _legendItem(context, l10n.egresos, AppTheme.errorColor),
      ],
    );
  }

  Widget _legendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<_ChartDataPoint> _processData() {
    final now = DateTime.now();
    final List<_ChartDataPoint> result = [];
    
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayMovs = movimientos.where((m) => 
        m.fecha.year == date.year && 
        m.fecha.month == date.month && 
        m.fecha.day == date.day
      );
      
      final ingresos = dayMovs.where((m) => m.tipo == MovimientoType.ingreso).fold(0.0, (s, m) => s + m.monto);
      final egresos = dayMovs.where((m) => m.tipo == MovimientoType.egreso).fold(0.0, (s, m) => s + m.monto);
      
      result.add(_ChartDataPoint(
        label: DateFormat('E').format(date).substring(0, 1),
        ingresos: ingresos,
        egresos: egresos,
      ));
    }
    return result;
  }

  LineChartBarData _createLineSeries(List<_ChartDataPoint> data, {required bool isIngreso}) {
    return LineChartBarData(
      spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), isIngreso ? e.value.ingresos : e.value.egresos)).toList(),
      isCurved: true,
      curveSmoothness: 0.3,
      color: isIngreso ? AppTheme.tertiaryColor : AppTheme.errorColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (isIngreso ? AppTheme.tertiaryColor : AppTheme.errorColor).withValues(alpha: 0.15),
            (isIngreso ? AppTheme.tertiaryColor : AppTheme.errorColor).withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  double _calculateMaxY(List<_ChartDataPoint> data) {
    final maxValue = data.fold<double>(
      0.0,
      (current, point) => math.max(current, math.max(point.ingresos, point.egresos)),
    );
    if (maxValue <= 0) return 1.0;

    final paddedMax = maxValue * 1.15;
    final interval = _getNiceInterval(paddedMax / 4);
    return (paddedMax / interval).ceil() * interval;
  }

  double _calculateInterval(List<_ChartDataPoint> data) {
    final maxY = _calculateMaxY(data);
    return _getNiceInterval(maxY / 4);
  }

  double _getNiceInterval(double value) {
    if (value <= 0) return 1.0;
    final magnitude = math.pow(10, (math.log(value) / math.ln10).floor()).toDouble();
    final normalized = value / magnitude;
    final niceNormalized = normalized <= 1
        ? 1
        : normalized <= 2
            ? 2
            : normalized <= 5
                ? 5
                : 10;
    return niceNormalized * magnitude;
  }
}

class _ChartDataPoint {
  final String label;
  final double ingresos;
  final double egresos;

  _ChartDataPoint({required this.label, required this.ingresos, required this.egresos});
}
