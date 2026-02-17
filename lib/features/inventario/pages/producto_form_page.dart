import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../inventario_viewmodel.dart';
import '../producto.dart';
import '../../proveedores/proveedores_viewmodel.dart';

const String _kCustomProveedorValue = '__custom__';

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
  final _codigoBarrasController = TextEditingController();
  final _proveedorNombreController = TextEditingController();
  String? _proveedorId;

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      _nombreController.text = widget.producto!.nombre;
      _cantidadController.text = widget.producto!.cantidad.toString();
      _precioController.text = widget.producto!.precio.toString();
      _categoriaController.text = widget.producto!.categoria;
      _proveedorId = widget.producto!.proveedorId.isEmpty
          ? _kCustomProveedorValue
          : widget.producto!.proveedorId;
      if (widget.producto!.codigoBarras != null) {
        _codigoBarrasController.text = widget.producto!.codigoBarras!;
      }
      if (widget.producto!.proveedorNombre != null) {
        _proveedorNombreController.text = widget.producto!.proveedorNombre!;
      }
    } else if (widget.initialCodigoBarras != null) {
      _codigoBarrasController.text = widget.initialCodigoBarras!;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    _categoriaController.dispose();
    _codigoBarrasController.dispose();
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
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  hintText: '0',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la cantidad';
                  }
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad < 0) {
                    return 'Cantidad debe ser un número válido (≥ 0)';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el precio';
                  }
                  final precio = double.tryParse(value.replaceAll(',', '.'));
                  if (precio == null || precio < 0) {
                    return 'Precio debe ser un número válido (≥ 0)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  hintText: 'Ej. Tintas, Papel',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese la categoría';
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
                      child: Text('-- Seleccionar proveedor --'),
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

  void _saveProducto() {
    if (!_formKey.currentState!.validate()) return;

    final proveedorId = _useCustomProveedor ? '' : (_proveedorId ?? '');
    final proveedorNombre = _useCustomProveedor
        ? _proveedorNombreController.text.trim()
        : null;
    final codigo = _codigoBarrasController.text.trim();
    final codigoBarras = codigo.isEmpty ? null : codigo;

    final viewModel = context.read<InventarioViewModel>();
    final precio = double.parse(_precioController.text.replaceAll(',', '.'));

    if (widget.producto == null) {
      viewModel.agregar(
        nombre: _nombreController.text.trim(),
        cantidad: int.parse(_cantidadController.text),
        precio: precio,
        categoria: _categoriaController.text.trim(),
        proveedorId: proveedorId.isEmpty ? '' : proveedorId,
        codigoBarras: codigoBarras,
        proveedorNombre: proveedorNombre,
      );
    } else {
      viewModel.editar(
        id: widget.producto!.id,
        nombre: _nombreController.text.trim(),
        cantidad: int.parse(_cantidadController.text),
        precio: precio,
        categoria: _categoriaController.text.trim(),
        proveedorId: proveedorId.isEmpty ? '' : proveedorId,
        codigoBarras: codigoBarras,
        proveedorNombre: proveedorNombre,
      );
    }
    Navigator.pop(context);
  }
}
