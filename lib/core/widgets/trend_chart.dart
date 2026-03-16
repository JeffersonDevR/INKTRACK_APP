import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';

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
    
    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Tendencia (Últimos $days días)',
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
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: Color(0xFFF1F5F9),
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
                              fontSize: 10,
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
                            fontSize: 10,
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
    return Row(
      children: [
        _legendItem('Ingresos', AppTheme.secondaryColor),
        const SizedBox(width: 12),
        _legendItem('Egresos', AppTheme.errorColor),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
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
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
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
      color: isIngreso ? AppTheme.secondaryColor : AppTheme.errorColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (isIngreso ? AppTheme.secondaryColor : AppTheme.errorColor).withValues(alpha: 0.15),
            (isIngreso ? AppTheme.secondaryColor : AppTheme.errorColor).withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  double _calculateMaxY(List<_ChartDataPoint> data) {
    double max = 0;
    for (var p in data) {
      if (p.ingresos > max) max = p.ingresos;
      if (p.egresos > max) max = p.egresos;
    }
    return max == 0 ? 1000 : max * 1.2;
  }

  double _calculateInterval(List<_ChartDataPoint> data) {
    final max = _calculateMaxY(data);
    return (max / 4).clamp(1.0, double.infinity);
  }
}

class _ChartDataPoint {
  final String label;
  final double ingresos;
  final double egresos;

  _ChartDataPoint({required this.label, required this.ingresos, required this.egresos});
}
