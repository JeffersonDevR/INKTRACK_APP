import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/features/locales/data/repositories/locales_repository.dart';

class MigracionItem {
  final String id;
  final void Function(String newLocalId) apply;

  MigracionItem({required this.id, required this.apply});
}

class LocalesViewModel extends BaseCrudViewModel<Local> {
  final LocalesRepository _repository;

  String? _localIdSeleccionado;
  bool _migracionRealizada = false;
  List<MigracionItem>? _pendientes;

  LocalesViewModel(this._repository) {
    _loadLocales();
  }

  String? get localIdSeleccionado => _localIdSeleccionado;

  Local? get localActual {
    if (_localIdSeleccionado == null) return null;
    try {
      return items.firstWhere((l) => l.id == _localIdSeleccionado);
    } catch (_) {
      return null;
    }
  }

  List<Local> get locales {
    return items.where((l) => l.isActivo).toList();
  }

  bool get tieneDatosSinLocal =>
      _migracionRealizada == false && localActual != null;

  bool get hayLocalesCargados => items.isNotEmpty;

  void seleccionarLocal(String? id) {
    _localIdSeleccionado = id;
    notifyListeners();
  }

  Future<void> migrarDatosExistentes({
    required List<MigracionItem> productosSinLocal,
    required List<MigracionItem> clientesSinLocal,
    required List<MigracionItem> proveedoresSinLocal,
    required List<MigracionItem> movimientosSinLocal,
  }) async {
    if (_localIdSeleccionado == null) return;
    if (_migracionRealizada) return;

    if (productosSinLocal.isEmpty &&
        clientesSinLocal.isEmpty &&
        proveedoresSinLocal.isEmpty &&
        movimientosSinLocal.isEmpty) {
      _migracionRealizada = true;
      return;
    }

    _pendientes = [
      ...productosSinLocal,
      ...clientesSinLocal,
      ...proveedoresSinLocal,
      ...movimientosSinLocal,
    ];

    _migracionRealizada = true;
  }

  void aplicarMigracionPendiente() {
    if (_localIdSeleccionado == null || _pendientes == null) return;
    for (final item in _pendientes!) {
      item.apply(_localIdSeleccionado!);
    }
    _pendientes = null;
    notifyListeners();
  }

  void marcarMigracionCompletada() {
    _migracionRealizada = true;
    notifyListeners();
  }

  Future<void> _loadLocales() async {
    clearAll();
    final loaded = await _repository.getAll();
    for (var local in loaded) {
      add(local);
    }
    if (_localIdSeleccionado == null && items.isNotEmpty) {
      _localIdSeleccionado = items.first.id;
    }
  }

  @override
  Future<void> refresh() async {
    await _loadLocales();
    notifyListeners();
  }

  Future<void> guardar(Local local) async {
    String finalId = local.id;
    bool isNew = finalId.isEmpty;

    if (isNew) {
      finalId = IdUtils.generateTimestampId();
    }

    final localAGuardar = local.copyWith(id: finalId);

    if (isNew) {
      await _repository.save(localAGuardar);
      add(localAGuardar);
    } else {
      final existingIndex = items.indexWhere((l) => l.id == finalId);
      if (existingIndex != -1) {
        await _repository.update(finalId, localAGuardar);
        update(finalId, localAGuardar);
      } else {
        await _repository.save(localAGuardar);
        add(localAGuardar);
      }
    }
  }

  Future<void> eliminar(String id) async {
    await _repository.delete(id);
    delete(id);
    if (_localIdSeleccionado == id) {
      _localIdSeleccionado = items.isNotEmpty ? items.first.id : null;
      notifyListeners();
    }
  }

  List<Local> get localesActivos => items.where((l) => l.isActivo).toList();
}
