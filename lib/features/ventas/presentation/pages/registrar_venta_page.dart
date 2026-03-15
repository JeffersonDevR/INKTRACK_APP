import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/ventas/presentation/viewmodels/ventas_viewmodel.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/core/input_formatters.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
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
  final _cantidadController = TextEditingController(text: '1');
  String? _clienteId;
  String? _productoId;
  bool _esFiado = false;
  static const String _kWriteNameValue = '__write_name__';

  @override
  void dispose() {
    _montoController.dispose();
    _clienteNombreController.dispose();
    _conceptoController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  //Guardar venta
  void _guardarVenta() {
    if (!_formKey.currentState!.validate()) return;

    final monto = double.parse(_montoController.text.replaceAll(',', '.'));
    String? clienteNombre;
    if (_clienteId == _kWriteNameValue) {
      clienteNombre = _clienteNombreController.text.trim();
      if (clienteNombre.isEmpty) {
        return;
      }
    }

    final venta = Venta(
      id: '', // New sale
      monto: monto,
      fecha: DateTime.now(),
      clienteId: _clienteId == _kWriteNameValue ? null : _clienteId,
      productoId: _productoId,
      cantidad: int.tryParse(_cantidadController.text) ?? 0,
      esFiado: _esFiado,
      clienteNombre: clienteNombre,
      concepto: _conceptoController.text.trim(),
    );

    context.read<VentasViewModel>().guardar(
          venta,
          movimientosVM: context.read<MovimientosViewModel>(),
          clientesVM: context.read<ClientesViewModel>(),
          inventarioVM: context.read<InventarioViewModel>(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Venta registrada con éxito'),
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
    final amount = await viewModel.procesarImagenOCR(image);

    if (amount != null) {
      _montoController.text = amount.toStringAsFixed(2);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Monto detectado: \$${amount.toStringAsFixed(2)}'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se detectó un monto claro. Intente de nuevo.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
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
            Text('Escanear Nota / Recibo', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ScanOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Cámara',
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAndScanImage(ImageSource.camera);
                  },
                ),
                _ScanOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Galería',
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickAndScanImage(ImageSource.gallery);
                  },
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
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Venta')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
                  Text(
                    'Monto de la venta',
                    style: Theme.of(context).textTheme.titleMedium,
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
                        icon: const Icon(Icons.document_scanner_rounded, size: 18),
                        label: const Text('Escanear'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          visualDensity: VisualDensity.compact,
                        ),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el monto';
                  }
                  final number = double.tryParse(value.replaceAll(',', '.'));
                  if (number == null || number <= 0) {
                    return 'El monto debe ser mayor a 0';
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
              Text(
                'Producto (opcional para stock)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Consumer<InventarioViewModel>(
                builder: (context, inventarioVM, child) {
                  return DropdownButtonFormField<String>(
                    initialValue: _productoId,
                    decoration: const InputDecoration(labelText: 'Producto'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Sin producto vinculado'),
                      ),
                      ...inventarioVM.productos.map((p) => DropdownMenuItem(
                            value: p.id,
                            child: Text('${p.nombre} (${p.cantidad} en stock)'),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _productoId = value;
                        // Pre-fill price and concept if product selected
                        if (value != null) {
                          final prod = inventarioVM.getById(value);
                          if (prod != null) {
                            if (_montoController.text.isEmpty) {
                              _montoController.text = prod.precio.toStringAsFixed(2);
                            }
                            if (_conceptoController.text.isEmpty) {
                              _conceptoController.text = 'Venta: ${prod.nombre}';
                            }
                          }
                        }
                      });
                    },
                  );
                },
              ),
              if (_productoId != null) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cantidadController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad vendida',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_productoId != null && (value == null || value.isEmpty)) {
                      return 'Ingrese la cantidad';
                    }
                    final n = int.tryParse(value!);
                    if (n == null || n <= 0) return 'Cantidad inválida';
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 24),
              if (_clienteId != null && _clienteId != _kWriteNameValue) ...[
                SwitchListTile(
                  title: const Text('Venta a crédito (Fiado)'),
                  subtitle: const Text('Aumentará el saldo pendiente del cliente'),
                  value: _esFiado,
                  onChanged: (value) {
                    setState(() => _esFiado = value);
                  },
                ),
              ],
              const SizedBox(height: 32),
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
