import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/pedidos_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/presentation/pages/barcode_scanner_page.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';

class CrearPedidoPage extends StatefulWidget {
  final String? initialProveedorId;

  const CrearPedidoPage({super.key, this.initialProveedorId});

  @override
  State<CrearPedidoPage> createState() => _CrearPedidoPageState();
}

class _CrearPedidoPageState extends State<CrearPedidoPage> {
  final _formKey = GlobalKey<FormState>();
  final _notasController = TextEditingController();
  final _montoController = TextEditingController(text: '0.00');

  String? _proveedorId;
  DateTime _fechaEntrega = DateTime.now().add(const Duration(days: 1));
  final List<_ProductoPedido> _productos = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _proveedorId = widget.initialProveedorId;
  }

  @override
  void dispose() {
    _notasController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  double get _montoTotal => _productos.fold(0.0, (sum, p) => sum + p.subtotal);

  void _actualizarMonto() {
    _montoController.text = NumberFormatter.formatCurrency(
      _montoTotal,
    ).replaceAll('\$', '');
  }

  Future<void> _agregarProducto() async {
    final result = await showModalBottomSheet<_ProductoPedido>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const _AgregarProductoSheet(),
    );

    if (result != null) {
      setState(() {
        _productos.add(result);
        _actualizarMonto();
      });
    }
  }

  Future<void> _escanearProducto() async {
    final producto = await Navigator.push<Producto>(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerPage(returnMode: true),
      ),
    );

    if (producto != null && mounted) {
      final cantidad = await _showCantidadDialog(producto);
      if (cantidad != null) {
        setState(() {
          _productos.add(
            _ProductoPedido(
              productoId: producto.id,
              nombre: producto.nombre,
              cantidad: cantidad,
              precioUnitario: producto.precio,
            ),
          );
          _actualizarMonto();
        });
      }
    }
  }

  Future<int?> _showCantidadDialog(Producto producto) async {
    final controller = TextEditingController(text: '1');
    return showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(producto.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Precio unitario: \$${producto.precio.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                helperText: 'Máximo 9999',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final cantidad = int.tryParse(controller.text);
              if (cantidad != null && cantidad > 0 && cantidad <= 9999) {
                Navigator.pop(ctx, cantidad);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cantidad inválida (máx 9999)')),
                );
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectFecha() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _fechaEntrega,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _fechaEntrega = date;
      });
    }
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_productos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agregue al menos un producto'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_isSaving) return;
    setState(() => _isSaving = true);

    final proveedorVM = context.read<ProveedoresViewModel>();
    final proveedor = proveedorVM.getById(_proveedorId!);

    final productos = _productos
        .map(
          (p) => PedidoProducto(
            productoId: p.productoId,
            nombre: p.nombre,
            cantidad: p.cantidad,
            precioUnitario: p.precioUnitario,
          ),
        )
        .toList();

    await context.read<PedidosProveedorViewModel>().crearPedido(
      proveedorId: _proveedorId!,
      proveedorNombre: proveedor?.nombre,
      fechaEntrega: _fechaEntrega,
      productos: productos,
      notas: _notasController.text.trim().isEmpty
          ? null
          : _notasController.text.trim(),
      movimientosVM: context.read<MovimientosViewModel>(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido creado correctamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Pedido')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Consumer<ProveedoresViewModel>(
              builder: (context, pvm, child) {
                final items = pvm.proveedores
                    .map(
                      (p) =>
                          DropdownMenuItem(value: p.id, child: Text(p.nombre)),
                    )
                    .toList();

                return DropdownButtonFormField<String>(
                  value: _proveedorId,
                  decoration: const InputDecoration(
                    labelText: 'Proveedor',
                    prefixIcon: Icon(Icons.local_shipping_outlined),
                  ),
                  items: items,
                  onChanged: (value) {
                    setState(() {
                      _proveedorId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Seleccione un proveedor';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectFecha,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha de entrega',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(dateFormat.format(_fechaEntrega)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Productos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _escanearProducto,
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text('Escanear'),
                    ),
                    TextButton.icon(
                      onPressed: _agregarProducto,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Agregar'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_productos.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: AppTheme.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      const Text('No hay productos agregados'),
                      const SizedBox(height: 4),
                      Text(
                        'Escanee o seleccione productos del inventario',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...List.generate(_productos.length, (index) {
                final producto = _productos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(producto.nombre),
                    subtitle: Text(
                      '${producto.cantidad} x ${currencyFormat.format(producto.precioUnitario)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currencyFormat.format(producto.subtotal),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _productos.removeAt(index);
                              _actualizarMonto();
                            });
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppTheme.errorColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notasController,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                prefixIcon: Icon(Icons.note_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Card(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      currencyFormat.format(_montoTotal),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _guardar,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Crear Pedido'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductoPedido {
  final String productoId;
  final String nombre;
  final int cantidad;
  final double precioUnitario;

  _ProductoPedido({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
  });

  double get subtotal => cantidad * precioUnitario;
}

class _AgregarProductoSheet extends StatefulWidget {
  const _AgregarProductoSheet({super.key});

  @override
  State<_AgregarProductoSheet> createState() => _AgregarProductoSheetState();
}

class _AgregarProductoSheetState extends State<_AgregarProductoSheet> {
  final _busquedaController = TextEditingController();
  final _cantidadController = TextEditingController(text: '1');
  final _precioController = TextEditingController();

  String? _productoSeleccionadoId;
  String? _productoSeleccionadoNombre;
  double _precioUnitario = 0;

  @override
  void dispose() {
    _busquedaController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Agregar Producto',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _busquedaController,
              decoration: const InputDecoration(
                labelText: 'Buscar producto',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (_productoSeleccionadoId == null)
              Expanded(
                child: Consumer<InventarioViewModel>(
                  builder: (context, invm, child) {
                    var productos = invm.productos;
                    final busqueda = _busquedaController.text
                        .trim()
                        .toLowerCase();
                    if (busqueda.isNotEmpty) {
                      productos = productos
                          .where(
                            (p) =>
                                p.nombre.toLowerCase().contains(busqueda) ||
                                p.categoria.toLowerCase().contains(busqueda),
                          )
                          .toList();
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        return ListTile(
                          title: Text(producto.nombre),
                          subtitle: Text(
                            'Stock: ${producto.cantidad} • \$${producto.precio.toStringAsFixed(2)}',
                          ),
                          onTap: () {
                            setState(() {
                              _productoSeleccionadoId = producto.id;
                              _productoSeleccionadoNombre = producto.nombre;
                              _precioUnitario = producto.precio;
                              _precioController.text = producto.precio
                                  .toString();
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      title: Text(_productoSeleccionadoNombre!),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _productoSeleccionadoId = null;
                            _productoSeleccionadoNombre = null;
                          });
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _precioController,
                    decoration: const InputDecoration(
                      labelText: 'Precio Unitario',
                      prefixText: '\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) {
                      _precioUnitario = double.tryParse(value) ?? 0;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final cantidad =
                            int.tryParse(_cantidadController.text) ?? 0;
                        if (_productoSeleccionadoId != null &&
                            cantidad > 0 &&
                            _precioUnitario > 0) {
                          Navigator.pop(
                            context,
                            _ProductoPedido(
                              productoId: _productoSeleccionadoId!,
                              nombre: _productoSeleccionadoNombre!,
                              cantidad: cantidad,
                              precioUnitario: _precioUnitario,
                            ),
                          );
                        }
                      },
                      child: const Text('Agregar'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
