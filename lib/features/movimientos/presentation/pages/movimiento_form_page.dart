import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/presentation/pages/barcode_scanner_page.dart';
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
  final _cantidadController = TextEditingController(text: '1');
  String? _categoria;
  String? _clienteId;
  String? _proveedorId;
  String? _productoId;
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
      _productoId = widget.movimiento!.productoId;
      _cantidadController.text = widget.movimiento!.cantidad?.toString() ?? '1';
      _esFiado = widget.movimiento!.esFiado;
      _fecha = widget.movimiento!.fecha;
    } else {
      _tipo = widget.initialType;
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
    _conceptoController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _scanProductBarcode() async {
    final result = await Navigator.push<Producto>(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerPage(returnMode: true),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _productoId = result.id;
        _montoController.text = NumberFormatter.formatCurrency(
          result.precio,
        ).replaceAll('\$', '');
        _cantidadController.text = '1';
      });
    }
  }

  void _updateMontoAuto() {
    if (_productoId == null) return;

    final ivm = context.read<InventarioViewModel>();
    final producto = ivm.productos.firstWhere(
      (p) => p.id == _productoId,
      orElse: () => Producto(
        id: '',
        nombre: '',
        cantidad: 0,
        precio: 0,
        categoria: '',
        proveedorId: '',
      ),
    );
    if (producto.id.isEmpty) return;

    final cantidad = int.tryParse(_cantidadController.text) ?? 0;

    setState(() {
      _montoController.text = NumberFormatter.formatCurrency(
        producto.precio * cantidad,
      ).replaceAll('\$', '');
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final monto = NumberFormatter.parseAmount(_montoController.text);
      final cantidad = int.tryParse(_cantidadController.text);

      final mov = Movimiento(
        id: widget.movimiento?.id ?? IdUtils.generateId(),
        monto: monto,
        fecha: _fecha,
        tipo: _tipo,
        concepto: _conceptoController.text,
        categoria: _categoria,
        clienteId: _clienteId,
        proveedorId: _proveedorId,
        productoId: _productoId,
        cantidad: cantidad,
        esFiado: _esFiado,
      );

      final viewModel = context.read<MovimientosViewModel>();
      final ivm = context.read<InventarioViewModel>();
      final cvm = context.read<ClientesViewModel>();

      // Stock Validation
      if (_productoId != null && cantidad != null) {
        final product = ivm.getById(_productoId!);
        if (product != null) {
          // In this app's logic: ingreso = sale (stock decrease), egreso = restock (stock increase)
          // Wait, let's double check line 111: delta = _tipo == MovimientoType.ingreso ? -cantidad : cantidad;
          // Yes, Ingreso decreases stock.
          if (_tipo == MovimientoType.ingreso && product.cantidad < cantidad) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'No hay suficiente stock. Disponible: ${product.cantidad}',
                ),
                backgroundColor: AppTheme.errorColor,
              ),
            );
            return;
          }
        }
      }

      if (widget.movimiento == null) {
        viewModel.guardar(mov);

        // Post-save hooks for NEW movements
        if (_productoId != null && cantidad != null) {
          final delta = _tipo == MovimientoType.ingreso ? -cantidad : cantidad;
          ivm.actualizarStock(_productoId!, delta);
        }

        if (_tipo == MovimientoType.ingreso && _esFiado && _clienteId != null) {
          cvm.actualizarSaldo(_clienteId!, monto);
        }
      } else {
        // REVERSAL Logic for existing movements
        final old = widget.movimiento!;
        bool reversalFailed = false;

        // 1. Revert Old Stock
        if (old.productoId != null && old.cantidad != null) {
          final oldProduct = ivm.productos.firstWhere(
            (p) => p.id == old.productoId,
            orElse: () => Producto(
              id: '',
              nombre: '',
              cantidad: 0,
              precio: 0,
              categoria: '',
              proveedorId: '',
            ),
          );
          if (oldProduct.id.isNotEmpty) {
            final deltaRevert = old.tipo == MovimientoType.ingreso
                ? old.cantidad!
                : -old.cantidad!;
            ivm.actualizarStock(old.productoId!, deltaRevert);
          } else {
            reversalFailed = true;
          }
        }

        // 2. Revert Old Debt (Saldo)
        if (old.tipo == MovimientoType.ingreso &&
            old.esFiado &&
            old.clienteId != null) {
          final oldClient = cvm.getById(old.clienteId!);
          if (oldClient != null) {
            cvm.actualizarSaldo(old.clienteId!, -old.monto);
          } else {
            reversalFailed = true;
          }
        }

        // 3. Apply New Stock
        if (_productoId != null && cantidad != null) {
          final newProduct = ivm.productos.firstWhere(
            (p) => p.id == _productoId,
            orElse: () => Producto(
              id: '',
              nombre: '',
              cantidad: 0,
              precio: 0,
              categoria: '',
              proveedorId: '',
            ),
          );
          if (newProduct.id.isNotEmpty) {
            final deltaApply = _tipo == MovimientoType.ingreso
                ? -cantidad
                : cantidad;
            ivm.actualizarStock(_productoId!, deltaApply);
          }
        }

        // 4. Apply New Debt (Saldo)
        if (_tipo == MovimientoType.ingreso && _esFiado && _clienteId != null) {
          final newClient = cvm.getById(_clienteId!);
          if (newClient != null) {
            cvm.actualizarSaldo(_clienteId!, monto);
          }
        }

        if (reversalFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Entidad original eliminada. Algunos cambios no se pudieron revertir.',
              ),
              backgroundColor: AppTheme.warningColor,
            ),
          );
        }

        viewModel.editar(old.id, mov);
      }
      Navigator.pop(context);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tipo == MovimientoType.ingreso ? 'Nuevo Ingreso' : 'Nuevo Egreso',
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
                segments: const [
                  ButtonSegment(
                    value: MovimientoType.ingreso,
                    label: Text('Ingreso'),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                  ButtonSegment(
                    value: MovimientoType.egreso,
                    label: Text('Egreso'),
                    icon: Icon(Icons.remove_circle_outline),
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
                        labelText: 'Monto Total',
                        prefixText: '\$ ',
                        hintText: '0.00',
                        helperText:
                            _productoId != null &&
                                _tipo == MovimientoType.ingreso
                            ? 'Monto calculado automáticamente'
                            : null,
                      ),
                      readOnly:
                          _productoId != null &&
                          _tipo == MovimientoType.ingreso,
                      enabled:
                          !(_productoId != null &&
                              _tipo == MovimientoType.ingreso),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [InputFormatters.decimal],
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Ingrese un monto';
                        final num = NumberFormatter.parseAmount(value);
                        if (num <= 0) return 'Monto inválido';
                        if (num > 999999999) return 'Máximo 999,999,999';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _cantidadController,
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [InputFormatters.digitsOnly],
                      onChanged: (value) => _updateMontoAuto(),
                      validator: (value) {
                        if (_productoId != null) {
                          if (value == null || value.isEmpty)
                            return 'Requerido';
                          if (int.tryParse(value) == null ||
                              int.parse(value) <= 0)
                            return '> 0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _conceptoController,
                decoration: const InputDecoration(
                  labelText: 'Concepto',
                  hintText: 'Ej. Venta de insumos',
                ),
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Ingrese un concepto';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<MovimientosViewModel>(
                builder: (context, mvm, child) {
                  final categories = mvm.categorias;
                  return DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: categories.contains(_categoria)
                        ? _categoria
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: Icon(Icons.category_outlined),
                      hintText: 'Seleccione una categoría',
                    ),
                    items: [
                      ...categories.map(
                        (c) => DropdownMenuItem(value: c, child: Text(c)),
                      ),
                      const DropdownMenuItem(
                        value: _kNewCategoryValue,
                        child: Text('+ Nueva categoría'),
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
                        return 'Seleccione o cree una categoría';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<ClientesViewModel>(
                builder: (context, cvm, child) {
                  // Removed type restriction as requested by user

                  final clientes = cvm.items;
                  return DropdownButtonFormField<String?>(
                    isExpanded: true,
                    initialValue: _clienteId,
                    decoration: const InputDecoration(
                      labelText: 'Cliente (Opcional)',
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'Seleccione un cliente',
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Ninguno'),
                      ),
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
                    initialValue: _proveedorId,
                    decoration: const InputDecoration(
                      labelText: 'Proveedor (Opcional)',
                      prefixIcon: Icon(Icons.local_shipping_outlined),
                      hintText: 'Seleccione un proveedor',
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Ninguno'),
                      ),
                      ...proveedores.map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.nombre),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() {
                      _proveedorId = value;
                    }),
                  );
                },
              ),
              if (_tipo == MovimientoType.ingreso && _clienteId != null) ...[
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Venta Fiada'),
                  subtitle: const Text('Añadir al saldo pendiente del cliente'),
                  value: _esFiado,
                  onChanged: (value) => setState(() => _esFiado = value),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  dense: true,
                ),
              ],
              const SizedBox(height: 16),
              Consumer<InventarioViewModel>(
                builder: (context, ivm, child) {
                  final productos = ivm.productos;
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          isExpanded: true,
                          initialValue: _productoId,
                          decoration: const InputDecoration(
                            labelText: 'Producto (Asociar)',
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                            hintText: 'Seleccione un producto',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Ninguno'),
                            ),
                            ...productos.map(
                              (p) => DropdownMenuItem(
                                value: p.id,
                                child: Text('${p.nombre} (\$${p.precio})'),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _productoId = value;
                              if (value != null) {
                                _updateMontoAuto();
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Material(
                        color: AppTheme.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: _scanProductBarcode,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.qr_code_scanner_rounded,
                              color: AppTheme.primaryColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Fecha'),
                subtitle: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _fecha = picked;
                    });
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
                child: const Text(
                  'GUARDAR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
