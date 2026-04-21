import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/presentation/pages/barcode_scanner_page.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/core/input_formatters.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:image_picker/image_picker.dart';

class RegistrarVentaPage extends StatefulWidget {
  const RegistrarVentaPage({super.key});

  @override
  State<RegistrarVentaPage> createState() => _RegistrarVentaPageState();
}

class _RegistrarVentaPageState extends State<RegistrarVentaPage> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _clienteNombreController = TextEditingController();
  final _conceptoController = TextEditingController();
  String? _clienteId;
  bool _esFiado = false;
  final List<_VentaItemState> _productos = [];
  static const String _kWriteNameValue = '__write_name__';

  @override
  void dispose() {
    _montoController.dispose();
    _clienteNombreController.dispose();
    _conceptoController.dispose();
    super.dispose();
  }

  double get _montoTotal => _productos.fold(0.0, (sum, p) => sum + p.subtotal);

  void _actualizarMonto() {
    _montoController.text = NumberFormatter.formatCurrency(
      _montoTotal,
    ).replaceAll('\$', '');
  }

  Future<void> _agregarProducto() async {
    final result = await showModalBottomSheet<_VentaItemState>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const _AgregarProductoSheet(),
    );

    if (result != null) {
      setState(() {
        final existingIndex = _productos.indexWhere(
          (p) => p.productoId == result.productoId,
        );
        if (existingIndex != -1) {
          _productos[existingIndex].cantidad += result.cantidad;
          _productos[existingIndex].precioUnitario = result.precioUnitario;
        } else {
          _productos.add(result);
        }
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
      if (cantidad != null && mounted) {
        setState(() {
          final existingIndex = _productos.indexWhere(
            (p) => p.productoId == producto.id,
          );
          if (existingIndex != -1) {
            _productos[existingIndex].cantidad += cantidad;
          } else {
            _productos.add(
              _VentaItemState(
                productoId: producto.id,
                nombre: producto.nombre,
                cantidad: cantidad,
                precioUnitario: producto.precio,
              ),
            );
          }
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
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              if (cantidad != null && cantidad > 0) {
                Navigator.pop(ctx, cantidad);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _guardarVenta() {
    if (!_formKey.currentState!.validate()) return;

    final monto = NumberFormatter.parseAmount(_montoController.text);
    String? clienteNombre;
    if (_clienteId == _kWriteNameValue) {
      clienteNombre = _clienteNombreController.text.trim();
      if (clienteNombre.isEmpty) {
        return;
      }
    }

    final inventarioVM = context.read<InventarioViewModel>();
    final localesVM = context.read<LocalesViewModel>();
    final localIdSeleccionado = localesVM.localIdSeleccionado;
    for (final prod in _productos) {
      final product = inventarioVM.getById(prod.productoId);
      if (product != null && !product.isActivo) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('El producto "${product.nombre}" está inactivo'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
      if (product != null && product.cantidad < prod.cantidad) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No hay suficiente stock de "${product.nombre}". Disponible: ${product.cantidad}',
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
    }

    final productosJson = _productos.isEmpty
        ? null
        : jsonEncode(
            _productos
                .map(
                  (p) => {
                    'productoId': p.productoId,
                    'nombre': p.nombre,
                    'cantidad': p.cantidad,
                    'precioUnitario': p.precioUnitario,
                  },
                )
                .toList(),
          );

    final venta = Venta(
      id: '',
      monto: monto,
      fecha: DateTime.now(),
      clienteId: _clienteId == _kWriteNameValue ? null : _clienteId,
      esFiado: _esFiado,
      clienteNombre: clienteNombre,
      concepto: _conceptoController.text.trim(),
      productosJson: productosJson,
      localId: localIdSeleccionado,
    );

    context.read<VentasViewModel>().guardar(
      venta,
      movimientosVM: context.read<MovimientosViewModel>(),
      clientesVM: context.read<ClientesViewModel>(),
      inventarioVM: inventarioVM,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Venta registrada con éxito'),
        backgroundColor: AppTheme.successColor,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _pickAndScanImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image == null) return;

    final viewModel = context.read<VentasViewModel>();
    final result = await viewModel.procesarImagenOCR(image);

    if (result != null) {
      bool foundSomething = false;

      if (result.amount != null) {
        _montoController.text = NumberFormatter.formatCurrency(
          result.amount!,
        ).replaceAll('\$', '');
        foundSomething = true;
      }

      if (result.clientName != null) {
        final clientName = result.clientName!;
        final clientesVM = context.read<ClientesViewModel>();
        final match = clientesVM.clientes.firstWhere(
          (c) =>
              c.nombre.toLowerCase().contains(clientName.toLowerCase()) ||
              clientName.toLowerCase().contains(c.nombre.toLowerCase()),
          orElse: () => Cliente(id: '', nombre: '', telefono: '', email: ''),
        );

        setState(() {
          if (match.id.isNotEmpty) {
            _clienteId = match.id;
            _clienteNombreController.clear();
          } else {
            _clienteId = _kWriteNameValue;
            _clienteNombreController.text = clientName;
          }
        });
        foundSomething = true;
      }

      if (foundSomething) {
        String message = 'Datos detectados:';
        if (result.amount != null) {
          message +=
              '\n- Monto: ${NumberFormatter.formatCurrency(result.amount!)}';
        }
        if (result.clientName != null) {
          message += '\n- Cliente: ${result.clientName}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se detectaron datos claros. Intente de nuevo.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _showScanMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Escanear Nota / Recibo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _ScanOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Cámara',
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickAndScanImage(ImageSource.camera);
                    },
                  ),
                ),
                Expanded(
                  child: _ScanOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Galería',
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickAndScanImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Venta')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text('Concepto', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _conceptoController,
              decoration: const InputDecoration(
                labelText: 'Concepto',
                hintText: 'Ej. Tatuaje ',
              ),
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: [InputFormatters.textOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingrese el concepto';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Monto de la venta',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Consumer<VentasViewModel>(
                  builder: (context, vm, _) {
                    if (vm.isScanning) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return TextButton.icon(
                      onPressed: _showScanMenu,
                      icon: const Icon(
                        Icons.document_scanner_rounded,
                        size: 18,
                      ),
                      label: const Text('Escanear'),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _montoController,
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: '\$ ',
                hintText: '0.00',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [InputFormatters.decimal],
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese el monto';
                }
                final number = NumberFormatter.parseAmount(value);
                if (number <= 0) {
                  return 'El monto debe ser mayor a 0';
                }
                if (number > 999999999) {
                  return 'Máximo 999,999,999';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Cliente (opcional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Consumer<ClientesViewModel>(
              builder: (context, clientesViewModel, child) {
                final items = <DropdownMenuItem<String>>[
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Sin cliente (venta general)'),
                  ),
                  ...clientesViewModel.clientes.map((cliente) {
                    return DropdownMenuItem(
                      value: cliente.id,
                      child: Text(cliente.nombre),
                    );
                  }),
                  const DropdownMenuItem(
                    value: _kWriteNameValue,
                    child: Text('Escribir nombre del cliente'),
                  ),
                ];
                return DropdownButtonFormField<String>(
                  initialValue: _clienteId,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                  items: items,
                  onChanged: (value) {
                    setState(() {
                      _clienteId = value;
                      if (value != _kWriteNameValue) {
                        _clienteNombreController.clear();
                      }
                    });
                  },
                );
              },
            ),
            if (_clienteId == _kWriteNameValue) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _clienteNombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del cliente',
                  hintText: 'Ej. Juan Pérez',
                ),
                textCapitalization: TextCapitalization.words,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (_clienteId == _kWriteNameValue &&
                      (value == null || value.trim().isEmpty)) {
                    return 'Ingrese el nombre del cliente';
                  }
                  return null;
                },
              ),
            ],
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
                      const Text('No hay productos'),
                      const SizedBox(height: 4),
                      Text(
                        'Escanee o agregue productos del inventario',
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
            const SizedBox(height: 24),
            if (_clienteId != null) ...[
              SwitchListTile(
                title: const Text('Venta a crédito (Fiado)'),
                subtitle: const Text(
                  'Aumentará el saldo pendiente del cliente',
                ),
                value: _esFiado,
                onChanged: (value) {
                  setState(() => _esFiado = value);
                },
              ),
            ],
            const SizedBox(height: 32),
            if (_productos.isNotEmpty)
              Card(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Productos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currencyFormat.format(_montoTotal),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _guardarVenta,
                child: const Text('Guardar venta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VentaItemState {
  final String productoId;
  final String nombre;
  int cantidad;
  double precioUnitario;

  _VentaItemState({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
  });

  double get subtotal => cantidad * precioUnitario;
}

class _AgregarProductoSheet extends StatefulWidget {
  const _AgregarProductoSheet();

  @override
  State<_AgregarProductoSheet> createState() => _AgregarProductoSheetState();
}

class _AgregarProductoSheetState extends State<_AgregarProductoSheet> {
  final _busquedaController = TextEditingController();
  String? _productoSeleccionadoId;
  String? _productoSeleccionadoNombre;
  double _precioUnitario = 0;
  final _cantidadController = TextEditingController(text: '1');
  final _precioController = TextEditingController();

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
                            _VentaItemState(
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

class _ScanOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ScanOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppTheme.primaryColor),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
