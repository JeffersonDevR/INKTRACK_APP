import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/data/repositories/productos_repository.dart';

class StockUpdateResult {
  final Producto previous;
  final Producto updated;

  StockUpdateResult({required this.previous, required this.updated});
}

class ActualizarStockUseCase {
  final ProductosRepository _repository;

  ActualizarStockUseCase(this._repository);

  Future<StockUpdateResult> call(String productoId, num delta) async {
    final producto = await _repository.getById(productoId);
    if (producto == null) {
      throw Exception('Producto no encontrado: $productoId');
    }

    final newCantidad = (producto.cantidad + delta.toInt()).clamp(0, 999999);
    final actualizado = producto.copyWith(cantidad: newCantidad);

    await _repository.update(productoId, actualizado);
    return StockUpdateResult(previous: producto, updated: actualizado);
  }
}
