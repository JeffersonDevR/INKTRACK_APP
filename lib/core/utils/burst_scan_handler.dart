class BurstScanResult {
  final String productoId;
  final String nombre;
  final int cantidad;
  final double precioUnitario;

  BurstScanResult({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
  });

  BurstScanResult copyWith({int? cantidad, double? precioUnitario}) {
    return BurstScanResult(
      productoId: productoId,
      nombre: nombre,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
    );
  }
}

class BurstScanHandler {
  final Duration debounceWindow;
  String? _lastCode;
  DateTime? _lastScanTime;

  BurstScanHandler({this.debounceWindow = const Duration(milliseconds: 250)});

  bool shouldProcess(String code) {
    final now = DateTime.now();
    if (_lastCode == code && _lastScanTime != null) {
      if (now.difference(_lastScanTime!) < debounceWindow) {
        return false;
      }
    }
    _lastCode = code;
    _lastScanTime = now;
    return true;
  }

  void reset() {
    _lastCode = null;
    _lastScanTime = null;
  }

  static List<BurstScanResult> incrementOrAdd(
    List<BurstScanResult> items,
    String productoId,
    String nombre,
    double precioUnitario,
  ) {
    final index = items.indexWhere((i) => i.productoId == productoId);
    if (index >= 0) {
      return [
        ...items.sublist(0, index),
        items[index].copyWith(cantidad: items[index].cantidad + 1),
        ...items.sublist(index + 1),
      ];
    }
    return [
      ...items,
      BurstScanResult(
        productoId: productoId,
        nombre: nombre,
        cantidad: 1,
        precioUnitario: precioUnitario,
      ),
    ];
  }
}
