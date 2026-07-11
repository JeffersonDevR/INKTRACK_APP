import 'package:flutter/material.dart';
import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/features/locales/data/repositories/locales_repository.dart';

class LocalesViewModel extends BaseCrudViewModel<Local> {
  final LocalesRepository _repository;

  String? _localIdSeleccionado;
  bool _migrationPromptedThisSession = false;

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

  /// Returns true when a local is selected AND migration has not been
  /// prompted/answered this session. The actual DB orphan check happens
  /// inside [migrateData] to avoid async in a getter.
  bool get tieneDatosSinLocal {
    return !_migrationPromptedThisSession && localActual != null;
  }

  bool get hayLocalesCargados => items.isNotEmpty;

  void seleccionarLocal(String? id) {
    _localIdSeleccionado = id;
    notifyListeners();
  }

  /// Consolidated migration path.
  ///
  /// 1. Queries the repository for orphaned row counts.
  /// 2. If [showDialog] is true, prompts the user with the counts.
  /// 3. Calls [assignLocalId] if the user accepts (or auto if
  ///    [showDialog] is false).
  /// 4. Sets the session guard so [tieneDatosSinLocal] returns false
  ///    afterwards.
  Future<void> migrateData(
    String localId, {
    bool showConfirmation = false,
    BuildContext? context,
  }) async {
    if (_migrationPromptedThisSession) return;
    if (localId.isEmpty) return;

    final summary = await _repository.getOrphanedCounts();
    if (summary.total == 0) {
      _migrationPromptedThisSession = true;
      return;
    }

    if (showConfirmation && context != null) {
      final debeMigrar = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Migrar datos al local'),
          content: Text(
            '¿Quieres asignar los ${summary.productos} productos, '
            '${summary.clientes} clientes, '
            '${summary.proveedores} proveedores y '
            '${summary.movimientos + summary.ventas + summary.pedidos} '
            'transacciones al local "${localActual?.nombre}"?\n\n'
            'Si no migras, los datos existentes no aparecerán en este local.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No migrar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Sí, migrar'),
            ),
          ],
        ),
      );

      if (debeMigrar != true) {
        _migrationPromptedThisSession = true;
        return;
      }
    }

    await _repository.assignLocalId(localId);
    _migrationPromptedThisSession = true;
    notifyListeners();
  }

  /// Legacy compat: marks migration as done without running it.
  /// Used by tests or pre-migrated data.
  void marcarMigracionCompletada() {
    _migrationPromptedThisSession = true;
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
      finalId = IdUtils.generateId();
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
