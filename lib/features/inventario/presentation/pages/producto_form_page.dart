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

class GananciaInfo {
  final bool isPositive;
  final double delta;
  final Color color;

  const GananciaInfo({
    required this.isPositive,
    required this.delta,
    required this.color,
  });
}

GananciaInfo? calcularGananciaInfo(String? precioVentaText, String? precioCompraText) {
  if (precioVentaText == null ||
      precioVentaText.isEmpty ||
      precioCompraText == null ||
      precioCompraText.isEmpty) {
    return null;
  }

  final venta = double.tryParse(precioVentaText.replaceAll(',', '.')) ?? 0.0;
  final compra = double.tryParse(precioCompraText.replaceAll(',', '.')) ?? 0.0;
  final delta = venta - compra;
  final isPositive = delta > 0;

  return GananciaInfo(
    isPositive: isPositive,
    delta: delta,
    color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
  );
}

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
        builder: (context) => const BarcodeScannerPage(
          mode: BarcodeScannerMode.scanCode,
        ),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        _codigoBarrasController.text = result;
      });
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
          content: Text(l10n.ingreseCodigoPersonalizadoPrimero),
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
                  hintText: l10n.ejemploNombreProducto,
                  counterText: '',
                ),
                maxLength: 40,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.ingreseNombreProducto;
                  }
                  if (value.trim().length < 2) {
                    return l10n.minimo2Caracteres;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codigoPersonalizadoController,
                decoration: InputDecoration(
                  labelText: l10n.codigoPersonalizado,
                  hintText: l10n.ejemploCodigoPersonalizado,
                  helperText: l10n.ayudaCodigoPersonalizado,
                  suffixIcon: _codigoPersonalizadoController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.link, size: 20),
                          onPressed: _vincularCodigoPersonalizado,
                          tooltip: l10n.vincularCodigoBarras,
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
                          ? l10n.vinculadoACodigoPersonalizado
                          : l10n.autoGenerado,
                        helperText: _vincularBarcode
                            ? '${l10n.codigoBarras}: ${_codigoBarrasController.text}'
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
                      label: Text(l10n.generar),
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
                  helperText: l10n.maximo99Unidades,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.ingreseCantidad;
                  }
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad < 0) {
                    return l10n.cantidadInvalida;
                  }
                  if (cantidad > 99) {
                    return l10n.maximo99Unidades;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(l10n.esPaqueteCaja),
                subtitle: Text(l10n.ventaPorUnidadesEmpaque),
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
                  decoration: InputDecoration(
                    labelText: l10n.unidadesPorPaquete,
                    hintText: 'Ej. 12, 24, 30',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (_esPaquete) {
                      if (value == null || value.isEmpty) {
                        return l10n.ingreseUnidades;
                      }
                      final units = int.tryParse(value);
                      if (units == null || units <= 0) {
                        return l10n.debeSerMayorACero;
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
                  helperText: l10n.maximoMonto,
                  suffixText: () {
                    final info = calcularGananciaInfo(
                      _precioVentaController.text,
                      _precioCompraController.text,
                    );
                    if (info == null) return null;
                    final sign = info.isPositive ? '+' : '-';
                    return '$sign \$${info.delta.abs().toStringAsFixed(0)}';
                  }(),
                  suffixStyle: TextStyle(
                    color: calcularGananciaInfo(
                      _precioVentaController.text,
                      _precioCompraController.text,
                    )?.color,
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
                    return l10n.ingresePrecio;
                  }
                  final precio = double.tryParse(value.replaceAll(',', '.'));
                  if (precio == null || precio < 0) {
                    return l10n.precioInvalido;
                  }
                  if (precio > 999999999) {
                    return l10n.maximoMonto;
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
                      hintText: l10n.seleccioneCategoria,
                    ),
                    isExpanded: true,
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
                          ivm.agregarCategoria(newCat);
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
              TextFormField(
                controller: _stockMinimoController,
                decoration: InputDecoration(
                  labelText: l10n.stockMinimo,
                  hintText: '5',
                  helperText: l10n.alertaStockBajo,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.ingreseStockMinimo;
                  }
                  final stock = int.tryParse(value);
                  if (stock == null || stock < 0) {
                    return l10n.stockMinimoInvalido;
                  }
                  if (stock > 9999) {
                    return l10n.maximo9999;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<ProveedoresViewModel>(
                builder: (context, pvm, child) {
                  final items = <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.seleccionarProveedor),
                    ),
                    ...pvm.proveedores.map(
                      (p) =>
                          DropdownMenuItem(value: p.id, child: Text(p.nombre)),
                    ),
                    DropdownMenuItem(
                      value: _kCustomProveedorValue,
                      child: Text(l10n.escribirNombreProveedor),
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
                        return l10n.seleccioneProveedorOEscribaNombre;
                      }
                      if (value == _kCustomProveedorValue &&
                          _proveedorNombreController.text.trim().isEmpty) {
                        return l10n.escribaNombreProveedor;
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
                    labelText: l10n.nombreProveedor,
                    hintText: l10n.ejemploProveedor,
                  ),
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [InputFormatters.textOnly],
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (_useCustomProveedor &&
                        (value == null || value.trim().isEmpty)) {
                      return l10n.ingreseNombreProveedor;
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
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.nuevaCategoria),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.nombreCategoria),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelar),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.agregar),
          ),
        ],
      ),
    );
  }

  void _saveProducto() async {
    final l10n = AppLocalizations.of(context)!;
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
      categoria: _categoria ?? l10n.otros,
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
                  ? l10n.productoGuardado
                  : l10n.productoActualizado,
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
              content: Text('${l10n.errorAlGuardar}: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  void _showProductoExisteDialog(String? codigoBarras) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.read<InventarioViewModel>();
    final productoExistente = codigoBarras != null
        ? viewModel.findProductoByCodigo(codigoBarras)
        : null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.productoYaExiste),
        content: Text(
          productoExistente != null
              ? l10n.productoYaExisteMensaje(
                  codigoBarras!,
                  productoExistente.nombre,
                )
              : l10n.productoYaExisteSimple,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancelar),
          ),
          if (productoExistente != null)
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, productoExistente);
              },
              child: Text(l10n.verProducto),
            ),
        ],
      ),
    );
  }
}
