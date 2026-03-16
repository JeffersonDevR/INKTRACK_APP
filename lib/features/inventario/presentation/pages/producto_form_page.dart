import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/core/input_formatters.dart';
import 'package:InkTrack/features/movimientos/presentation/pages/movimiento_form_page.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart' as mov_model;

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
  final _categoriaController = TextEditingController();
  final _stockMinimoController = TextEditingController(text: '5');
  final _codigoBarrasController = TextEditingController();
  final _codigoPersonalizadoController = TextEditingController();
  final _proveedorNombreController = TextEditingController();
  String? _proveedorId;
  String? _categoria;

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
        _codigoPersonalizadoController.text = widget.producto!.codigoPersonalizado!;
      }
      if (widget.producto!.proveedorNombre != null) {
        _proveedorNombreController.text = widget.producto!.proveedorNombre!;
      }
    } else if (widget.initialCodigoBarras != null) {
      _codigoBarrasController.text = widget.initialCodigoBarras!;
    }

    _codigoBarrasController.addListener(_checkBarcodeExistence);
  }

  void _checkBarcodeExistence() {
    if (widget.producto != null) return; // Only for new products
    final code = _codigoBarrasController.text.trim();
    if (code.isEmpty) return;

    final viewModel = context.read<InventarioViewModel>();
    final existing = viewModel.findProductoByCodigo(code);

    if (existing != null) {
      // If found, redirect to update stock
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Only if still mounted and we haven't already popped
        if (mounted) {
           Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MovimientoFormPage(
                initialType: mov_model.MovimientoType.egreso,
                movimiento: mov_model.Movimiento(
                  id: '',
                  monto: 0,
                  fecha: DateTime.now(),
                  tipo: mov_model.MovimientoType.egreso,
                  concepto: 'Restock: ${existing.nombre}',
                  productoId: existing.id,
                  categoria: existing.categoria,
                ),
              ),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    _categoriaController.dispose();
    _codigoBarrasController.dispose();
    _codigoPersonalizadoController.dispose();
    _proveedorNombreController.dispose();
    super.dispose();
  }

  bool get _useCustomProveedor => _proveedorId == _kCustomProveedorValue;

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
                ),
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese el nombre del producto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codigoBarrasController,
                decoration: const InputDecoration(
                  labelText: 'Código de barras / QR (opcional)',
                  hintText: 'O escanear con el botón',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codigoPersonalizadoController,
                      decoration: const InputDecoration(
                        labelText: 'Código Personalizado (opcional)',
                        hintText: 'Ej. PROD-001',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
                      _codigoPersonalizadoController.text = 'IT-${timestamp.substring(timestamp.length - 8)}';
                    },
                    icon: const Icon(Icons.auto_awesome),
                    tooltip: 'Generar código',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  hintText: '0',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [InputFormatters.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la cantidad';
                  }
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad < 0) {
                    return 'Cantidad inválida';
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
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [InputFormatters.decimal],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el precio';
                  }
                  final precio = double.tryParse(value.replaceAll(',', '.'));
                  if (precio == null || precio < 0) {
                    return 'Precio inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<InventarioViewModel>(
                builder: (context, ivm, child) {
                  final categories = ivm.categorias;
                  return DropdownButtonFormField<String>(
                    initialValue: categories.contains(_categoria) ? _categoria : (categories.isNotEmpty ? null : null),
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
                  helperText: 'Alerta cuando la cantidad.',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [InputFormatters.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el stock mínimo';
                  }
                  final stock = int.tryParse(value);
                  if (stock == null || stock < 0) {
                    return 'Stock mínimo inválido';
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

  void _saveProducto() {
    if (!_formKey.currentState!.validate()) return;

    final proveedorId = _useCustomProveedor ? '' : (_proveedorId ?? '');
    final proveedorNombre = _useCustomProveedor
        ? _proveedorNombreController.text.trim()
        : null;
    final codigo = _codigoBarrasController.text.trim();
    final codigoBarras = codigo.isEmpty ? null : codigo;
    final customCode = _codigoPersonalizadoController.text.trim();
    final codigoPersonalizado = customCode.isEmpty ? null : customCode;

    final viewModel = context.read<InventarioViewModel>();
    final precio = double.parse(_precioController.text.replaceAll(',', '.'));

    final producto = Producto(
      id: widget.producto?.id ?? '', // Empty ID means new (or barcode will take precedence in VM)
      nombre: _nombreController.text.trim(),
      cantidad: int.parse(_cantidadController.text),
      precio: precio,
      categoria: _categoria ?? 'Otros',
      stockMinimo: int.parse(_stockMinimoController.text),
      proveedorId: proveedorId.isEmpty ? '' : proveedorId,
      codigoBarras: codigoBarras,
      codigoPersonalizado: codigoPersonalizado,
      proveedorNombre: proveedorNombre,
    );

    viewModel.guardar(producto);
    
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
