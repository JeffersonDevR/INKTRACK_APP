import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/ventas/data/repositories/ventas_repository.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/core/services/scanner_service.dart';
import 'package:image_picker/image_picker.dart';

class VentasViewModel extends BaseCrudViewModel<Venta> {
  final VentasRepository _repository;
  final ScannerService? _scannerService;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  double? _lastScannedAmount;
  double? get lastScannedAmount => _lastScannedAmount;

  String? _lastScannedClientName;
  String? get lastScannedClientName => _lastScannedClientName;

  VentasViewModel(this._repository, [this._scannerService]) {
    _loadVentas();
  }

  List<Venta> get ventas => items;

  Future<void> _loadVentas() async {
    clearAll();
    final loaded = await _repository.getAll();
    for (var venta in loaded) {
      add(venta);
    }
  }

  @override
  Future<void> refresh() async {
    await _loadVentas();
    notifyListeners();
  }

  double get totalVentasDia {
    final now = DateTime.now();
    return items
        .where(
          (venta) =>
              venta.fecha.year == now.year &&
              venta.fecha.month == now.month &&
              venta.fecha.day == now.day,
        )
        .fold(0.0, (sum, item) => sum + item.monto);
  }

  Future<void> guardar(
    Venta venta, {
    MovimientosViewModel? movimientosVM,
    ClientesViewModel? clientesVM,
    InventarioViewModel? inventarioVM,
  }) async {
    if (venta.monto <= 0) return;

    final bool isNew = venta.id.isEmpty;
    final id = isNew ? IdUtils.generateTimestampId() : venta.id;

    String? finalClienteId = venta.clienteId;

    // Auto-create client if name is provided but ID is missing
    if (isNew &&
        finalClienteId == null &&
        venta.clienteNombre != null &&
        venta.clienteNombre!.isNotEmpty &&
        clientesVM != null) {
      finalClienteId = await clientesVM.agregar(
        nombre: venta.clienteNombre!,
        telefono: '',
        email: '',
        movimientosVM: movimientosVM,
      );
    }

    final ventaAGuardar = venta.copyWith(id: id, clienteId: finalClienteId);

    if (isNew) {
      await _repository.save(ventaAGuardar);
      add(ventaAGuardar);

      // side effects for new sales
      if (movimientosVM != null) {
        final rawConcepto = venta.concepto ?? 'Venta general';
        final finalConcepto = rawConcepto.toLowerCase().startsWith('venta:')
            ? rawConcepto
            : 'Venta: $rawConcepto';
        final movimiento = Movimiento(
          id: IdUtils.generateId(),
          monto: venta.monto,
          fecha: venta.fecha,
          tipo: MovimientoType.ingreso,
          concepto: finalConcepto,
          categoria: 'Ventas',
        );
        await movimientosVM.guardar(movimiento);
      }

      // auto-update stock
      if (inventarioVM != null &&
          venta.productoId != null &&
          venta.cantidad > 0) {
        await inventarioVM.actualizarStock(venta.productoId!, -venta.cantidad);
      }

      // auto-update client debt
      if (clientesVM != null && finalClienteId != null && venta.esFiado) {
        await clientesVM.actualizarSaldo(finalClienteId, venta.monto);
      }
    } else {
      await _repository.update(id, ventaAGuardar);
      update(id, ventaAGuardar);
    }
  }

  Future<void> eliminar(String id) async {
    await _repository.delete(id);
    delete(id);
  }

  List<Venta> getVentasPorCliente(String clienteId) =>
      items.where((venta) => venta.clienteId == clienteId).toList();

  Future<OcrResult?> procesarImagenOCR(XFile image) async {
    if (_scannerService == null) return null;

    _isScanning = true;
    _lastScannedAmount = null;
    _lastScannedClientName = null;
    notifyListeners();

    try {
      final result = await _scannerService.scanImage(image);
      _lastScannedAmount = result.amount;
      _lastScannedClientName = result.clientName;
      return result;
    } catch (e) {
      return null;
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  void clearScannedData() {
    _lastScannedAmount = null;
    _lastScannedClientName = null;
    notifyListeners();
  }
}
