import '../../../core/base_crud_viewmodel.dart';
import '../models/movimiento.dart';

class MovimientosViewModel extends BaseCrudViewModel<Movimiento> {
  final List<String> _categorias = ['Ventas', 'Servicios', 'Sueldos', 'Alquiler', 'Otros'];
  List<String> get categorias => List.unmodifiable(_categorias);

  void agregarCategoria(String nombre) {
    if (nombre.trim().isNotEmpty && !_categorias.contains(nombre.trim())) {
      _categorias.add(nombre.trim());
      notifyListeners();
    }
  }

  double get totalIngresos => items
      .where((m) => m.tipo == MovimientoType.ingreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get totalEgresos => items
      .where((m) => m.tipo == MovimientoType.egreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get balance => totalIngresos - totalEgresos;

  double get totalIngresosHoy {
    final now = DateTime.now();
    return items
        .where((m) =>
            m.tipo == MovimientoType.ingreso &&
            m.fecha.day == now.day &&
            m.fecha.month == now.month &&
            m.fecha.year == now.year)
        .fold(0.0, (sum, m) => sum + m.monto);
  }

  double get totalEgresosHoy {
    final now = DateTime.now();
    return items
        .where((m) =>
            m.tipo == MovimientoType.egreso &&
            m.fecha.day == now.day &&
            m.fecha.month == now.month &&
            m.fecha.year == now.year)
        .fold(0.0, (sum, m) => sum + m.monto);
  }

  double get balanceHoy => totalIngresosHoy - totalEgresosHoy;

  List<Movimiento> get ingresos =>
      items.where((m) => m.tipo == MovimientoType.ingreso).toList();

  List<Movimiento> get egresos =>
      items.where((m) => m.tipo == MovimientoType.egreso).toList();

  List<Movimiento> get historialCompleto =>
      items.toList()..sort((a, b) => b.fecha.compareTo(a.fecha));

  @override
  void add(Movimiento item) {
    super.add(item);
  }

  void eliminar(String id) => delete(id);

  void editar(String id, Movimiento nuevo) => update(id, nuevo);
}
