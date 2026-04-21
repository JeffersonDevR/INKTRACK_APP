import 'package:flutter/material.dart';
import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/features/locales/data/repositories/locales_repository.dart';
import 'package:InkTrack/features/inventario/data/repositories/drift_productos_repository.dart';
import 'package:InkTrack/features/clientes/data/repositories/drift_clientes_repository.dart';
import 'package:InkTrack/features/proveedores/data/repositories/drift_proveedores_repository.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';

class LocalesViewModel extends BaseCrudViewModel<Local> {
  final LocalesRepository _repository;
  final DriftProductosRepository? _productosRepo;
  final DriftClientesRepository? _clientesRepo;
  final DriftProveedoresRepository? _proveedoresRepo;

  String? _localIdSeleccionado;
  bool _migracionRealizada = false;

  LocalesViewModel(
    this._repository, {
    DriftProductosRepository? productosRepo,
    DriftClientesRepository? clientesRepo,
    DriftProveedoresRepository? proveedoresRepo,
  }) : _productosRepo = productosRepo,
       _clientesRepo = clientesRepo,
       _proveedoresRepo = proveedoresRepo {
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

  bool get tieneDatosSinLocal {
    return _migracionRealizada == false && localActual != null;
  }

  bool get hayLocalesCargados => items.isNotEmpty;

  void seleccionarLocal(String? id) {
    _localIdSeleccionado = id;
    notifyListeners();
  }

  Future<void> migrarDatosExistentes({
    required InventarioViewModel invVM,
    required ClientesViewModel cliVM,
    required ProveedoresViewModel provVM,
    required BuildContext context,
  }) async {
    if (_localIdSeleccionado == null) return;
    if (_migracionRealizada) return;

    final productosSinLocal = invVM.items
        .where((p) => p.localId == null)
        .toList();
    final clientesSinLocal = cliVM.items
        .where((c) => c.localId == null)
        .toList();
    final proveedoresSinLocal = provVM.items
        .where((p) => p.localId == null)
        .toList();

    if (productosSinLocal.isEmpty &&
        clientesSinLocal.isEmpty &&
        proveedoresSinLocal.isEmpty) {
      _migracionRealizada = true;
      return;
    }

    final debeMigrar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Migrar datos al local'),
        content: Text(
          '¿Quieres asignar los ${productosSinLocal.length} productos, '
          '${clientesSinLocal.length} clientes y '
          '${proveedoresSinLocal.length} proveedores al local "${localActual?.nombre}"?\n\n'
          'Si no migras, los datos existentes no aparecerán en este local.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No migrate'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, migrate'),
          ),
        ],
      ),
    );

    if (debeMigrar != true) {
      _migracionRealizada = true;
      return;
    }

    final productosActualizados = <Producto>[];
    for (final p in productosSinLocal) {
      final actualizado = p.copyWith(localId: _localIdSeleccionado);
      await _productosRepo?.update(p.id, actualizado);
      invVM.update(p.id, actualizado);
      productosActualizados.add(actualizado);
    }

    final clientesActualizados = <Cliente>[];
    for (final c in clientesSinLocal) {
      final actualizado = c.copyWith(localId: _localIdSeleccionado);
      await _clientesRepo?.update(c.id, actualizado);
      cliVM.update(c.id, actualizado);
      clientesActualizados.add(actualizado);
    }

    final proveedoresActualizados = <Proveedor>[];
    for (final p in proveedoresSinLocal) {
      final actualizado = p.copyWith(localId: _localIdSeleccionado);
      await _proveedoresRepo?.update(p.id, actualizado);
      provVM.update(p.id, actualizado);
      proveedoresActualizados.add(actualizado);
    }

    _migracionRealizada = true;
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
