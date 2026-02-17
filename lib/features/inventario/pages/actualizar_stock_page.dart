import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/producto.dart';
import '../viewmodels/inventario_viewmodel.dart';
import '../../../core/theme/app_theme.dart';

class ActualizarStockPage extends StatefulWidget {
  final Producto producto;

  const ActualizarStockPage({super.key, required this.producto});

  @override
  State<ActualizarStockPage> createState() => _ActualizarStockPageState();
}

class _ActualizarStockPageState extends State<ActualizarStockPage> {
  late int _cantidad;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cantidad = widget.producto.cantidad;
    _controller.text = _cantidad.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateCantidad(int delta) {
    setState(() {
      _cantidad = (_cantidad + delta).clamp(0, 9999);
      _controller.text = _cantidad.toString();
    });
  }

  void _save() {
    final newCantidad = int.tryParse(_controller.text) ?? _cantidad;
    final updatedProducto = Producto(
      id: widget.producto.id,
      nombre: widget.producto.nombre,
      cantidad: newCantidad,
      precio: widget.producto.precio,
      categoria: widget.producto.categoria,
      proveedorId: widget.producto.proveedorId,
      codigoBarras: widget.producto.codigoBarras,
      proveedorNombre: widget.producto.proveedorNombre,
    );

    context.read<InventarioViewModel>().guardar(updatedProducto);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Stock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: AppTheme.primaryColor.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      widget.producto.nombre,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Código: ${widget.producto.codigoBarras ?? widget.producto.id}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                'Cantidad actual',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _IconButton(
                  icon: Icons.remove,
                  onPressed: () => _updateCantidad(-1),
                  color: AppTheme.errorColor,
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (value) {
                      final val = int.tryParse(value);
                      if (val != null) {
                        setState(() => _cantidad = val);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 24),
                _IconButton(
                  icon: Icons.add,
                  onPressed: () => _updateCantidad(1),
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Guardar Cambios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _IconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 32),
        onPressed: onPressed,
      ),
    );
  }
}
