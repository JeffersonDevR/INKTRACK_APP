import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/presentation/pages/barcode_scanner_page.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/input_formatters.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';

const String _kNewCategoryValue = '__new_category__';

class MovimientoFormPage extends StatefulWidget {
  final MovimientoType initialType;
  final Movimiento? movimiento;

  const MovimientoFormPage({
    super.key,
    this.initialType = MovimientoType.egreso,
    this.movimiento,
  });

  @override
  State<MovimientoFormPage> createState() => _MovimientoFormPageState();
}

class _MovimientoFormPageState extends State<MovimientoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late MovimientoType _tipo;
  final _montoController = TextEditingController();
  final _conceptoController = TextEditingController();
  String? _categoria;
  String? _clienteId;
  String? _proveedorId;
  final List<_MovimientoProductoState> _productos = [];
  bool _esFiado = false;
  DateTime _fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.movimiento != null) {
      _tipo = widget.movimiento!.tipo;
      _montoController.text = widget.movimiento!.monto.toString();
      _conceptoController.text = widget.movimiento!.concepto;
      _categoria = widget.movimiento!.categoria;
      _clienteId = widget.movimiento!.clienteId;
      _proveedorId = widget.movimiento!.proveedorId;
      _esFiado = widget.movimiento!.esFiado;
      _fecha = widget.movimiento!.fecha;

      if (widget.movimiento!.isMultiProducto) {
        for (final p in widget.movimiento!.productos) {
          _productos.add(
            _MovimientoProductoState(
              productoId: p.productoId,
              nombre: p.nombre,
              cantidad: p.cantidad,
              precioUnitario: p.precioUnitario,
            ),
          );
        }
      }
    } else {
      _tipo = widget.initialType;
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
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
    final result = await showModalBottomSheet<_MovimientoProductoState>(
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
              _MovimientoProductoState(
                productoId: producto.id,
                nombre: producto.nombre,
                cantidad: cantidad,
                precioUnitario: producto.precioVenta,
              ),
            );
          }
          _actualizarMonto();
        });
      }
    }
  }

  Future<double?> _showCantidadDialog(Producto producto) async {
    final controller = TextEditingController(text: '1');
    return showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(producto.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Precio unitario: \$${producto.precioVenta.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              final cantidad = double.tryParse(controller.text);
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

  Future<String?> _showAddCategoryDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Categoría'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nombre de la categoría'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final monto = NumberFormatter.parseAmount(_montoController.text);
    final ivm = context.read<InventarioViewModel>();

    if (_tipo == MovimientoType.ingreso) {
      for (final prod in _productos) {
        final product = ivm.getById(prod.productoId);
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

    final mov = Movimiento(
      id: widget.movimiento?.id ?? IdUtils.generateId(),
      monto: monto,
      fecha: _fecha,
      tipo: _tipo,
      concepto: _conceptoController.text,
      categoria: _categoria,
      clienteId: _clienteId,
      proveedorId: _proveedorId,
      esFiado: _esFiado,
      productosJson: productosJson,
    );

    final viewModel = context.read<MovimientosViewModel>();
    final cvm = context.read<ClientesViewModel>();
    final localesVM = context.read<LocalesViewModel>();

    if (widget.movimiento == null) {
      final movConLocal = Movimiento(
        id: mov.id,
        monto: mov.monto,
        fecha: mov.fecha,
        tipo: mov.tipo,
        concepto: mov.concepto,
        categoria: mov.categoria,
        clienteId: mov.clienteId,
        proveedorId: mov.proveedorId,
        esFiado: mov.esFiado,
        productosJson: mov.productosJson,
        localId: localesVM.localIdSeleccionado,
      );
      viewModel.guardar(movConLocal);

      for (final prod in _productos) {
        final delta = _tipo == MovimientoType.ingreso
            ? -prod.cantidad
            : prod.cantidad;
        ivm.actualizarStock(prod.productoId, delta);
      }

      if (_tipo == MovimientoType.ingreso && _esFiado && _clienteId != null) {
        cvm.actualizarSaldo(_clienteId!, monto);
      }
    } else {
      final old = widget.movimiento!;

      if (old.isMultiProducto) {
        for (final p in old.productos) {
          final deltaRevert = old.tipo == MovimientoType.ingreso
              ? p.cantidad
              : -p.cantidad;
          ivm.actualizarStock(p.productoId, deltaRevert);
        }
      } else if (old.productoId != null && old.cantidad != null) {
        final deltaRevert = old.tipo == MovimientoType.ingreso
            ? old.cantidad!
            : -old.cantidad!;
        ivm.actualizarStock(old.productoId!, deltaRevert);
      }

      for (final prod in _productos) {
        final deltaApply = _tipo == MovimientoType.ingreso
            ? -prod.cantidad
            : prod.cantidad;
        ivm.actualizarStock(prod.productoId, deltaApply);
      }

      viewModel.editar(old.id, mov);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tipo == MovimientoType.ingreso
              ? l10n.nuevoIngreso
              : l10n.nuevoEgreso,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<MovimientoType>(
                segments: [
                  ButtonSegment(
                    value: MovimientoType.ingreso,
                    label: Text(l10n.ingreso),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  ButtonSegment(
                    value: MovimientoType.egreso,
                    label: Text(l10n.egreso),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                ],
                selected: {_tipo},
                onSelectionChanged: (Set<MovimientoType> newSelection) {
                  setState(() {
                    _tipo = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _montoController,
                      decoration: InputDecoration(
                        labelText: l10n.montoTotal,
                        prefixText: '\$ ',
                        hintText: '0.00',
                        helperText: _productos.isNotEmpty
                            ? l10n.calculadoAutomaticamente
                            : null,
                      ),
                      readOnly: _productos.isNotEmpty,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [InputFormatters.decimal],
                      onChanged: (_) => setState(() {}),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return l10n.ingreseMonto;
                        final num = NumberFormatter.parseAmount(value);
                        if (num <= 0) return l10n.montoInvalido;
                        if (num > 999999999) return l10n.maximoMonto;
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _conceptoController,
                decoration: InputDecoration(
                  labelText: l10n.concepto,
                  hintText: l10n.ingreseConceptoVenta,
                ),
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return l10n.ingreseConcepto;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<MovimientosViewModel>(
                builder: (context, mvm, child) {
                  final categories = mvm.categorias;
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: categories.contains(_categoria) ? _categoria : null,
                    decoration: InputDecoration(
                      labelText: l10n.categoria,
                      prefixIcon: const Icon(Icons.category_outlined),
                      hintText: l10n.seleccioneCategoria,
                    ),
                    items: [
                      ...categories.map(
                        (c) => DropdownMenuItem(value: c, child: Text(c)),
                      ),
                      DropdownMenuItem(
                        value: _kNewCategoryValue,
                        child: Text('+ ${l10n.nuevaCategoria}'),
                      ),
                    ],
                    onChanged: (value) async {
                      if (value == _kNewCategoryValue) {
                        final newCat = await _showAddCategoryDialog();
                        if (newCat != null && newCat.isNotEmpty) {
                          mvm.agregarCategoria(newCat);
                          setState(() => _categoria = newCat);
                        }
                      } else {
                        setState(() => _categoria = value);
                      }
                    },
                    validator: (value) {
                      if (_categoria == null || _categoria!.isEmpty) {
                        return l10n.seleccioneOCreeCategoria;
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<ClientesViewModel>(
                builder: (context, cvm, child) {
                  final clientes = cvm.items;
                  return DropdownButtonFormField<String?>(
                    isExpanded: true,
                    value: _clienteId,
                    decoration: InputDecoration(
                      labelText: l10n.clienteOpcionalLabel,
                      prefixIcon: const Icon(Icons.person_outline),
                      hintText: l10n.seleccionarLocal,
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.ninguno)),
                      ...clientes.map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(
                            '${c.nombre}${c.saldoPendiente > 0 ? " (${NumberFormatter.formatCurrency(c.saldoPendiente)})" : ""}',
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() {
                      _clienteId = value;
                      if (value == null) _esFiado = false;
                    }),
                  );
                },
              ),
              Consumer<ProveedoresViewModel>(
                builder: (context, pvm, child) {
                  if (_tipo == MovimientoType.ingreso)
                    return const SizedBox.shrink();
                  final proveedores = pvm.proveedores;
                  return DropdownButtonFormField<String?>(
                    isExpanded: true,
                    value: _proveedorId,
                    decoration: InputDecoration(
                      labelText: l10n.proveedorOpcional,
                      prefixIcon: const Icon(Icons.local_shipping_outlined),
                      hintText: l10n.seleccionarLocal,
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.ninguno)),
                      ...proveedores.map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.nombre),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _proveedorId = value),
                  );
                },
              ),
              if (_tipo == MovimientoType.ingreso && _clienteId != null) ...[
                const SizedBox(height: 8),
                SwitchListTile(
                  title: Text(l10n.ventaFiada),
                  subtitle: Text(l10n.anadirSaldoPendiente),
                  value: _esFiado,
                  onChanged: (value) => setState(() => _esFiado = value),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.productos,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: _escanearProducto,
                        icon: const Icon(Icons.qr_code_scanner, size: 18),
                        label: Text(l10n.escanear),
                      ),
                      TextButton.icon(
                        onPressed: _agregarProducto,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.agregar),
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
                        Text(l10n.noHayProductos),
                        const SizedBox(height: 4),
                        Text(
                          l10n.escaneeOAgregueProductos,
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
              if (_productos.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.totalProductos,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
              ],
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(l10n.fecha),
                subtitle: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _fecha = picked);
                  }
                },
                trailing: const Icon(Icons.edit_calendar),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _tipo == MovimientoType.ingreso
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  l10n.guardar.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovimientoProductoState {
  final String productoId;
  final String nombre;
  double cantidad;
  double precioUnitario;

  _MovimientoProductoState({
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
                            'Stock: ${producto.cantidad} • \$${producto.precioVenta.toStringAsFixed(2)}',
                          ),
                          onTap: () {
                            setState(() {
                              _productoSeleccionadoId = producto.id;
                              _productoSeleccionadoNombre = producto.nombre;
                              _precioUnitario = producto.precioVenta;
                              _precioController.text = producto.precioVenta
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
                        onPressed: () =>
                            setState(() => _productoSeleccionadoId = null),
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                    onChanged: (value) =>
                        _precioUnitario = double.tryParse(value) ?? 0,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final cantidad =
                            double.tryParse(_cantidadController.text) ?? 0;
                        if (_productoSeleccionadoId != null &&
                            cantidad > 0 &&
                            _precioUnitario > 0) {
                          Navigator.pop(
                            context,
                            _MovimientoProductoState(
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
                  ),                ],
              ),
          ],
        ),
      ),
    );
  }
}
