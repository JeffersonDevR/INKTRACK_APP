import 'package:InkTrack/core/base_crud_viewmodel.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/ventas/data/repositories/ventas_repository.dart';
import 'package:InkTrack/features/ventas/domain/use_cases/registrar_venta_use_case.dart';
import 'package:InkTrack/core/services/scanner_service.dart';
import 'package:image_picker/image_picker.dart';

class VentasViewModel extends BaseCrudViewModel<Venta> {
  final VentasRepository _repository;
  final RegistrarVentaUseCase _registrarVenta;
  final ScannerService? _scannerService;
  String? _localId;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  double? _lastScannedAmount;
  double? get lastScannedAmount => _lastScannedAmount;

  String? _lastScannedClientName;
  String? get lastScannedClientName => _lastScannedClientName;

  VentasViewModel(this._repository, this._registrarVenta, [this._scannerService]) {
    _loadVentas();
  }

  void setLocalId(String? localId) {
    _localId = localId;
    notifyListeners();
  }

  List<Venta> get _ventasFiltradas {
    if (_localId == null) return items;
    return items.where((v) => v.localId == _localId).toList();
  }

  List<Venta> get ventas => _ventasFiltradas;

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
    return _ventasFiltradas
        .where(
          (venta) =>
              venta.fecha.year == now.year &&
              venta.fecha.month == now.month &&
              venta.fecha.day == now.day,
        )
        .fold(0.0, (sum, item) => sum + item.monto);
  }

  Future<void> guardar(Venta venta) async {
    if (venta.monto <= 0) return;

    if (venta.id.isEmpty) {
      final result = await _registrarVenta(venta);
      add(result.venta);
    } else {
      await _repository.update(venta.id, venta);
      update(venta.id, venta);
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
