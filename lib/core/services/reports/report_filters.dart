// lib/core/services/reports/report_filters.dart
class ReportFilters {
  final bool soloDeudores;
  final bool abonosDelMes;
  final bool topVendidos;
  final bool inventarioCriticoValorizado;
  final bool incluirCosto;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? clienteId;
  final String? productoId;
  final int? topN;

  const ReportFilters({
    this.soloDeudores = false,
    this.abonosDelMes = false,
    this.topVendidos = false,
    this.inventarioCriticoValorizado = false,
    this.incluirCosto = false,
    this.startDate,
    this.endDate,
    this.clienteId,
    this.productoId,
    this.topN,
  });

  ReportFilters copyWith({
    bool? soloDeudores,
    bool? abonosDelMes,
    bool? topVendidos,
    bool? inventarioCriticoValorizado,
    bool? incluirCosto,
    DateTime? startDate,
    DateTime? endDate,
    String? clienteId,
    String? productoId,
    int? topN,
  }) {
    return ReportFilters(
      soloDeudores: soloDeudores ?? this.soloDeudores,
      abonosDelMes: abonosDelMes ?? this.abonosDelMes,
      topVendidos: topVendidos ?? this.topVendidos,
      inventarioCriticoValorizado: inventarioCriticoValorizado ?? this.inventarioCriticoValorizado,
      incluirCosto: incluirCosto ?? this.incluirCosto,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      clienteId: clienteId ?? this.clienteId,
      productoId: productoId ?? this.productoId,
      topN: topN ?? this.topN,
    );
  }
}
