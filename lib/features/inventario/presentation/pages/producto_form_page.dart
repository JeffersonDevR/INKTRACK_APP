import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/core/input_formatters.dart';
import 'package:InkTrack/core/utils/ean13_generator.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/pages/barcode_scanner_page.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

const String _kCustomProveedorValue = '__custom__';
const String _kNewCategoryValue = '__new_category__';

class ProductoFormPage extends StatefulWidget {
  final Producto? producto;
  final String? initialCodigoBarras;

  const ProductoFormPage({super.key, this.producto, this.initialCodigoBarras});

  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();
}

class _ProductoFormPageState extends State<ProductoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _precioVentaController = TextEditingController();
  final _precioCompraController = TextEditingController();
  final _stockMinimoController = TextEditingController(text: '5');
  final _codigoBarrasController = TextEditingController();
  final _codigoPersonalizadoController = TextEditingController();
  final _proveedorNombreController = TextEditingController();
  final _unidadesPorPaqueteController = TextEditingController(text: '1');
  String? _proveedorId;
  String? _categoria;
  bool _vincularBarcode = false;
  bool _esPaquete = false;

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      _nombreController.text = widget.producto!.nombre;
      _cantidadController.text = widget.producto!.cantidad.toString();
      _precioVentaController.text = widget.producto!.precioVenta.toString();
      _precioCompraController.text = widget.producto!.precioCompra?.toString() ?? '';
      _categoria = widget.producto!.categoria;
      _stockMinimoController.text = widget.producto!.stockMinimo.toString();
      _esPaquete = widget.producto!.esPaquete;
      _unidadesPorPaqueteController.text = widget.producto!.unidadesPorPaquete.toString();
      _proveedorId = widget.producto!.proveedorId.isEmpty
          ? _kCustomProveedorValue
          : widget.producto!.proveedorId;
      if (widget.producto!.codigoBarras != null) {
        _codigoBarrasController.text = widget.producto!.codigoBarras!;
      }
      if (widget.producto!.codigoPersonalizado != null) {
        _codigoPersonalizadoController.text =
            widget.producto!.codigoPersonalizado!;
      }
      if (widget.producto!.proveedorNombre != null) {
        _proveedorNombreController.text = widget.producto!.proveedorNombre!;
      }
    } else if (widget.initialCodigoBarras != null) {
      _codigoBarrasController.text = widget.initialCodigoBarras!;
    }

    _precioVentaController.addListener(_updateGanancia);
    _precioCompraController.addListener(_updateGanancia);
  }

  void _updateGanancia() {
    setState(() {});
  }

  void _generateBarcode() {
    final barcode = Ean13Generator.generate();
    setState(() {
      _codigoBarrasController.text = barcode;
    });
  }

  Future<void> _scanBarcode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerPage(returnMode: true),
      ),
    );

    if (result != null) {
      if (result is Producto) {
        setState(() {
          _codigoBarrasController.text = result.codigoBarras ?? '';
        });
      } else if (result is String) {
        setState(() {
          _codigoBarrasController.text = result;
        });
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _precioVentaController.dispose();
    _precioCompraController.dispose();
    _stockMinimoController.dispose();
    _codigoBarrasController.dispose();
    _codigoPersonalizadoController.dispose();
    _proveedorNombreController.dispose();
    _unidadesPorPaqueteController.dispose();
    super.dispose();
  }

  bool get _useCustomProveedor => _proveedorId == _kCustomProveedorValue;

  void _vincularCodigoPersonalizado() {
    final l10n = AppLocalizations.of(context)!;
    if (_codigoPersonalizadoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter a custom code first'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }
    final barcode = Ean13Generator.generate();
    setState(() {
      _codigoBarrasController.text = barcode;
      _vincularBarcode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.producto == null ? l10n.nuevoProducto : l10n.editarProducto,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: l10n.nombre,
                  hintText: 'Ex. Black ink 50ml',
                  counterText: '',
                ),
                maxLength: 40,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter product name';
                  }
                  if (value.trim().length < 2) {
                    return 'Minimum 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codigoPersonalizadoController,
                decoration: InputDecoration(
                  labelText: 'Custom code',
                  hintText: 'Client/supplier code',
                  helperText: 'Ex. ZAP-001, PAP-045 (optional)',
                  suffixIcon: _codigoPersonalizadoController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.link, size: 20),
                          onPressed: _vincularCodigoPersonalizado,
                          tooltip: 'Link to barcode',
                        )
                      : null,
                ),
                maxLength: 30,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codigoBarrasController,
                      decoration: InputDecoration(
                        labelText: '${l10n.codigoBarras} (EAN-13)',
                        hintText: _vincularBarcode
                            ? 'Linked to custom code'
                            : 'Auto-generated',
                        helperText: _vincularBarcode
                            ? 'Code: ${_codigoBarrasController.text}'
                            : null,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                              onPressed: _scanBarcode,
                            ),
                            if (_codigoBarrasController.text.isNotEmpty)
                              const Icon(
                                Icons.qr_code,
                                color: AppTheme.successColor,
                              ),
                          ],
                        ),
                      ),
                      readOnly: true,
                    ),
                  ),
                  if (widget.producto == null) ...[
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _generateBarcode,
                      icon: const Icon(Icons.qr_code),
                      label: const Text('Generate'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                decoration: InputDecoration(
                  labelText: l10n.cantidad,
                  hintText: '0 - 99',
                  helperText: 'Maximum 99 units',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter quantity';
                  }
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad < 0) {
                    return 'Invalid quantity';
                  }
                  if (cantidad > 99) {
                    return 'Maximum 99 units';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Es Paquete/Caja'),
                subtitle: const Text('Venta por unidades dentro de un empaque'),
                value: _esPaquete,
                onChanged: (value) {
                  setState(() {
                    _esPaquete = value;
                  });
                },
              ),
              if (_esPaquete) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _unidadesPorPaqueteController,
                  decoration: const InputDecoration(
                    labelText: 'Unidades por Paquete',
                    hintText: 'Ej. 12, 24, 30',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (_esPaquete) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese unidades';
                      }
                      final units = int.tryParse(value);
                      if (units == null || units <= 0) {
                        return 'Debe ser mayor a 0';
                      }
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioCompraController,
                decoration: InputDecoration(
                  labelText: l10n.precioCompra,
                  hintText: '0.00',
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,9}$')),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioVentaController,
                decoration: InputDecoration(
                  labelText: l10n.precioVenta,
                  hintText: '0.00',
                  prefixText: '\$ ',
                  helperText: 'Maximum 9,999,999',
                  suffixText: 'Ganancia: \$${(double.tryParse(_precioVentaController.text.replaceAll(',', '.')) ?? 0) - (double.tryParse(_precioCompraController.text.replaceAll(',', '.')) ?? 0)}',
                  suffixStyle: const TextStyle(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,9}$')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter price';
                  }
                  final precio = double.tryParse(value.replaceAll(',', '.'));
                  if (precio == null || precio < 0) {
                    return 'Invalid price';
                  }
                  if (precio > 999999999) {
                    return 'Maximum 999,999,999';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<InventarioViewModel>(
                builder: (context, ivm, child) {
                  final categories = ivm.categorias;
                  return DropdownButtonFormField<String>(
                    initialValue: categories.contains(_categoria)
                        ? _categoria
                        : (categories.isNotEmpty ? null : null),
                    decoration: InputDecoration(
                      labelText: l10n.categoria,
                      hintText: 'Select a category',
                    ),
                    isExpanded: true,
                    items: [
                      ...categories.map(
                        (c) => DropdownMenuItem(value: c, child: Text(c)),
                      ),
                      const DropdownMenuItem(
                        value: _kNewCategoryValue,
                        child: Text('+ New category'),
                      ),
                    ],
                    onChanged: (value) async {
                      if (value == _kNewCategoryValue) {
                        final newCat = await _showAddCategoryDialog();
                        if (newCat != null && newCat.isNotEmpty) {
                          ivm.agregarCategoria(newCat);
                          setState(() => _categoria = newCat);
                        }
                      } else {
                        setState(() => _categoria = value);
                      }
                    },
                    validator: (value) {
                      if (_categoria == null || _categoria!.isEmpty) {
                        return 'Select or create a category';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockMinimoController,
                decoration: InputDecoration(
                  labelText: l10n.stockMinimo,
                  hintText: '5',
                  helperText: 'Alert when quantity falls below this level',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter minimum stock';
                  }
                  final stock = int.tryParse(value);
                  if (stock == null || stock < 0) {
                    return 'Invalid minimum stock';
                  }
                  if (stock > 9999) {
                    return 'Maximum 9999';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<ProveedoresViewModel>(
                builder: (context, pvm, child) {
                  final items = <DropdownMenuItem<String>>[
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Select supplier'),
                    ),
                    ...pvm.proveedores.map(
                      (p) =>
                          DropdownMenuItem(value: p.id, child: Text(p.nombre)),
                    ),
                    const DropdownMenuItem(
                      value: _kCustomProveedorValue,
                      child: Text('Write supplier name'),
                    ),
                  ];
                  return DropdownButtonFormField<String>(
                    initialValue: _proveedorId,
                    decoration: InputDecoration(labelText: l10n.proveedor),
                    isExpanded: true,
                    items: items,
                    onChanged: (value) {
                      setState(() {
                        _proveedorId = value;
                        if (value != _kCustomProveedorValue) {
                          _proveedorNombreController.clear();
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select a supplier or use "Write name"';
                      }
                      if (value == _kCustomProveedorValue &&
                          _proveedorNombreController.text.trim().isEmpty) {
                        return 'Write the supplier name';
                      }
                      return null;
                    },
                  );
                },
              ),
              if (_useCustomProveedor) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _proveedorNombreController,
                  decoration: InputDecoration(
                    labelText: '${l10n.proveedor} name',
                    hintText: 'Ex. Distributor XYZ',
                  ),
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [InputFormatters.textOnly],
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (_useCustomProveedor &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Enter the supplier name';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProducto,
                  child: Text(
                    widget.producto == null
                        ? l10n.guardar
                        : l10n.guardarActualizar,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showAddCategoryDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Category name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveProducto() async {
    if (!_formKey.currentState!.validate()) return;

    final proveedorId = _useCustomProveedor ? '' : (_proveedorId ?? '');
    final proveedorNombre = _useCustomProveedor
        ? _proveedorNombreController.text.trim()
        : null;
    final codigo = _codigoBarrasController.text.trim();
    final codigoBarras = codigo.isEmpty ? null : codigo;
    final codigoPersonalizado =
        _codigoPersonalizadoController.text.trim().isEmpty
        ? null
        : _codigoPersonalizadoController.text.trim();

    final viewModel = context.read<InventarioViewModel>();
    final localesVM = context.read<LocalesViewModel>();
    final precioVenta = double.parse(_precioVentaController.text.replaceAll(',', '.'));
    final precioCompra = _precioCompraController.text.isNotEmpty
        ? double.parse(_precioCompraController.text.replaceAll(',', '.'))
        : null;

    final producto = Producto(
      id: widget.producto?.id ?? '',
      nombre: _nombreController.text.trim(),
      cantidad: int.parse(_cantidadController.text),
      precioVenta: precioVenta,
      precioCompra: precioCompra,
      unidadesPorPaquete: int.parse(_unidadesPorPaqueteController.text),
      esPaquete: _esPaquete,
      categoria: _categoria ?? 'Others',
      stockMinimo: int.parse(_stockMinimoController.text),
      proveedorId: proveedorId.isEmpty ? '' : proveedorId,
      localId: widget.producto?.localId ?? localesVM.localIdSeleccionado,
      codigoBarras: codigoBarras,
      codigoPersonalizado: codigoPersonalizado,
      proveedorNombre: proveedorNombre,
      isActivo: widget.producto?.isActivo ?? true,
    );

    try {
      await viewModel.guardar(producto);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.producto == null
                  ? 'Product created successfully'
                  : 'Product updated successfully',
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted && e.toString().contains('ya existe')) {
        _showProductoExisteDialog(codigoBarras);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  void _showProductoExisteDialog(String? codigoBarras) {
    final viewModel = context.read<InventarioViewModel>();
    final productoExistente = codigoBarras != null
        ? viewModel.findProductoByCodigo(codigoBarras)
        : null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Product already exists'),
        content: Text(
          productoExistente != null
              ? 'A product with this barcode already exists:\n\n${productoExistente.nombre}\nStock: ${productoExistente.cantidad}\nPrice: \$${productoExistente.precioVenta.toStringAsFixed(2)}'
              : 'A product with this barcode already exists.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          if (productoExistente != null)
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, productoExistente);
              },
              child: const Text('View product'),
            ),
        ],
      ),
    );
  }
}
