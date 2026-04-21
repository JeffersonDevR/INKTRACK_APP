import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';

class MovimientosViewModel extends BaseCrudViewModel<Movimiento> {
  final MovimientosRepository _repository;
  String? _localId;

  MovimientosViewModel(this._repository) {
    _loadMovimientos();
  }

  void setLocalId(String? localId) {
    _localId = localId;
    notifyListeners();
  }

  List<Movimiento> get _itemsFiltrados {
    if (_localId == null) return items;
    return items.where((m) => m.localId == _localId).toList();
  }

  final List<String> _categorias = [
    'Ventas',
    'Servicios',
    'Sueldos',
    'Alquiler',
    'Otros',
  ];
  List<String> get categorias => List.unmodifiable(_categorias);

  DateTime? _startDateFilter;
  DateTime? _endDateFilter;

  DateTime? get startDateFilter => _startDateFilter;
  DateTime? get endDateFilter => _endDateFilter;

  void setDateFilter(DateTime start, DateTime end) {
    _startDateFilter = start;
    _endDateFilter = end;
    notifyListeners();
  }

  void clearDateFilter() {
    _startDateFilter = null;
    _endDateFilter = null;
    notifyListeners();
  }

  double get totalIngresos => _itemsFiltrados
      .where((m) => m.tipo == MovimientoType.ingreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get totalEgresos => _itemsFiltrados
      .where((m) => m.tipo == MovimientoType.egreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get balance => totalIngresos - totalEgresos;

  List<Movimiento> get filteredItems {
    var base = _itemsFiltrados;
    if (startDateFilter == null)
      return base..sort((a, b) => b.fecha.compareTo(a.fecha));

    return base.where((m) {
      final mDate = DateTime(m.fecha.year, m.fecha.month, m.fecha.day);
      final startDate = DateTime(
        startDateFilter!.year,
        startDateFilter!.month,
        startDateFilter!.day,
      );
      final endDate = endDateFilter != null
          ? DateTime(
              endDateFilter!.year,
              endDateFilter!.month,
              endDateFilter!.day,
            )
          : null;

      final isAfterStart = !mDate.isBefore(startDate);
      final isBeforeEnd = endDate == null || !mDate.isAfter(endDate);
      return isAfterStart && isBeforeEnd;
    }).toList()..sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  double get totalIngresosFiltered => filteredItems
      .where((m) => m.tipo == MovimientoType.ingreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get totalEgresosFiltered => filteredItems
      .where((m) => m.tipo == MovimientoType.egreso)
      .fold(0.0, (sum, m) => sum + m.monto);

  double get balanceFiltered => totalIngresosFiltered - totalEgresosFiltered;

  Future<void> _loadMovimientos() async {
    clearAll();
    final loaded = await _repository.getAll();
    for (var movimiento in loaded) {
      add(movimiento);
    }
  }

  @override
  Future<void> refresh() async {
    await _loadMovimientos();
    notifyListeners();
  }

  void agregarCategoria(String nombre) {
    if (nombre.trim().isNotEmpty && !_categorias.contains(nombre.trim())) {
      _categorias.add(nombre.trim());
      notifyListeners();
    }
  }

  double get totalIngresosHoy {
    final now = DateTime.now();
    return _itemsFiltrados
        .where(
          (m) =>
              m.tipo == MovimientoType.ingreso &&
              m.fecha.day == now.day &&
              m.fecha.month == now.month &&
              m.fecha.year == now.year,
        )
        .fold(0.0, (sum, m) => sum + m.monto);
  }

  double get totalEgresosHoy {
    final now = DateTime.now();
    return _itemsFiltrados
        .where(
          (m) =>
              m.tipo == MovimientoType.egreso &&
              m.fecha.day == now.day &&
              m.fecha.month == now.month &&
              m.fecha.year == now.year,
        )
        .fold(0.0, (sum, m) => sum + m.monto);
  }

  double get balanceHoy => totalIngresosHoy - totalEgresosHoy;

  List<Movimiento> get ingresos =>
      _itemsFiltrados.where((m) => m.tipo == MovimientoType.ingreso).toList();

  List<Movimiento> get egresos =>
      _itemsFiltrados.where((m) => m.tipo == MovimientoType.egreso).toList();

  List<Movimiento> get historialCompleto =>
      _itemsFiltrados.toList()..sort((a, b) => b.fecha.compareTo(a.fecha));

  @override
  void add(Movimiento item) {
    super.add(item);
  }

  Future<void> guardar(Movimiento movimiento) async {
    await _repository.save(movimiento);
    add(movimiento);
  }

  Future<void> eliminar(String id) async {
    await _repository.delete(id);
    delete(id);
  }

  Future<void> editar(String id, Movimiento nuevo) async {
    await _repository.update(id, nuevo);
    update(id, nuevo);
  }
}
