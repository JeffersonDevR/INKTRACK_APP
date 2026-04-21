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
  final _precioController = TextEditingController();
  final _stockMinimoController = TextEditingController(text: '5');
  final _codigoBarrasController = TextEditingController();
  final _codigoPersonalizadoController = TextEditingController();
  final _proveedorNombreController = TextEditingController();
  String? _proveedorId;
  String? _categoria;
  bool _vincularBarcode = false;

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      _nombreController.text = widget.producto!.nombre;
      _cantidadController.text = widget.producto!.cantidad.toString();
      _precioController.text = widget.producto!.precio.toString();
      _categoria = widget.producto!.categoria;
      _stockMinimoController.text = widget.producto!.stockMinimo.toString();
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
  }

  void _generateBarcode() {
    final barcode = Ean13Generator.generate();
    setState(() {
      _codigoBarrasController.text = barcode;
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    _stockMinimoController.dispose();
    _codigoBarrasController.dispose();
    _codigoPersonalizadoController.dispose();
    _proveedorNombreController.dispose();
    super.dispose();
  }

  bool get _useCustomProveedor => _proveedorId == _kCustomProveedorValue;

  void _vincularCodigoPersonalizado() {
    if (_codigoPersonalizadoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese un código personalizado primero'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.producto == null ? 'Nuevo Producto' : 'Editar Producto',
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
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Ej. Tinta negra 50ml',
                  counterText: '',
                ),
                maxLength: 40,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese el nombre del producto';
                  }
                  if (value.trim().length < 2) {
                    return 'Mínimo 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codigoPersonalizadoController,
                decoration: InputDecoration(
                  labelText: 'Código personalizado',
                  hintText: 'Código del cliente/proveedor',
                  helperText: 'Ej. ZAP-001, PAP-045 (opcional)',
                  suffixIcon: _codigoPersonalizadoController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.link, size: 20),
                          onPressed: _vincularCodigoPersonalizado,
                          tooltip: 'Vincular a código de barras',
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
                        labelText: 'Código de barras (EAN-13)',
                        hintText: _vincularBarcode
                            ? 'Vinculado al código personalizado'
                            : 'Se genera automáticamente',
                        helperText: _vincularBarcode
                            ? 'Código: ${_codigoBarrasController.text}'
                            : null,
                        suffixIcon: _codigoBarrasController.text.isNotEmpty
                            ? const Icon(
                                Icons.qr_code,
                                color: AppTheme.successColor,
                              )
                            : null,
                      ),
                      readOnly: true,
                    ),
                  ),
                  if (widget.producto == null) ...[
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _generateBarcode,
                      icon: const Icon(Icons.qr_code),
                      label: const Text('Generar'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  hintText: '0 - 99',
                  helperText: 'Máximo 99 unidades',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la cantidad';
                  }
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad < 0) {
                    return 'Cantidad inválida';
                  }
                  if (cantidad > 99) {
                    return 'Máximo 99 unidades';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  hintText: '0.00',
                  prefixText: '\$ ',
                  helperText: 'Máximo 9,999,999',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,9}$')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el precio';
                  }
                  final precio = double.tryParse(value.replaceAll(',', '.'));
                  if (precio == null || precio < 0) {
                    return 'Precio inválido';
                  }
                  if (precio > 999999999) {
                    return 'Máximo 999,999,999';
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
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      hintText: 'Seleccione una categoría',
                    ),
                    isExpanded: true,
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
                          ivm.agregarCategoria(newCat);
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
              TextFormField(
                controller: _stockMinimoController,
                decoration: const InputDecoration(
                  labelText: 'Stock Mínimo',
                  hintText: '5',
                  helperText: 'Alerta cuando la cantidad baje de este nivel',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el stock mínimo';
                  }
                  final stock = int.tryParse(value);
                  if (stock == null || stock < 0) {
                    return 'Stock mínimo inválido';
                  }
                  if (stock > 9999) {
                    return 'Máximo 9999';
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
                      child: Text('Seleccionar proveedor'),
                    ),
                    ...pvm.proveedores.map(
                      (p) =>
                          DropdownMenuItem(value: p.id, child: Text(p.nombre)),
                    ),
                    const DropdownMenuItem(
                      value: _kCustomProveedorValue,
                      child: Text('Escribir nombre de proveedor'),
                    ),
                  ];
                  return DropdownButtonFormField<String>(
                    initialValue: _proveedorId,
                    decoration: const InputDecoration(labelText: 'Proveedor'),
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
                        return 'Seleccione un proveedor o use "Escribir nombre"';
                      }
                      if (value == _kCustomProveedorValue &&
                          _proveedorNombreController.text.trim().isEmpty) {
                        return 'Escriba el nombre del proveedor';
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
                  decoration: const InputDecoration(
                    labelText: 'Nombre del proveedor',
                    hintText: 'Ej. Distribuidora XYZ',
                  ),
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [InputFormatters.textOnly],
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (_useCustomProveedor &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Ingrese el nombre del proveedor';
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
                    widget.producto == null ? 'Guardar producto' : 'Actualizar',
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
    final precio = double.parse(_precioController.text.replaceAll(',', '.'));

    final producto = Producto(
      id: widget.producto?.id ?? '',
      nombre: _nombreController.text.trim(),
      cantidad: int.parse(_cantidadController.text),
      precio: precio,
      categoria: _categoria ?? 'Otros',
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
                  ? 'Producto creado correctamente'
                  : 'Producto actualizado correctamente',
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
              content: Text('Error al guardar: $e'),
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
        title: const Text('Producto ya existe'),
        content: Text(
          productoExistente != null
              ? 'Ya existe un producto con este código de barras:\n\n${productoExistente.nombre}\nStock: ${productoExistente.cantidad}\nPrecio: \$${productoExistente.precio.toStringAsFixed(2)}'
              : 'Ya existe un producto con este código de barras.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          if (productoExistente != null)
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, productoExistente);
              },
              child: const Text('Ver producto'),
            ),
        ],
      ),
    );
  }
}
