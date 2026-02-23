import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ventas_viewmodel.dart';
import '../models/venta.dart';
import '../../clientes/viewmodels/clientes_viewmodel.dart';
import '../../movimientos/viewmodels/movimientos_viewmodel.dart';
import '../../../core/input_formatters.dart';
import '../../../core/theme/app_theme.dart';

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
  static const String _kWriteNameValue = '__write_name__';

  @override
  void dispose() {
    _montoController.dispose();
    _clienteNombreController.dispose();
    _conceptoController.dispose();
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
      clienteNombre: clienteNombre,
      concepto: _conceptoController.text.trim(),
    );

    context.read<VentasViewModel>().guardar(
          venta,
          movimientosVM: context.read<MovimientosViewModel>(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Venta registrada con éxito'),
        backgroundColor: AppTheme.successColor,
      ),
    );
    Navigator.pop(context);
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
              Text(
                'Monto de la venta',
                style: Theme.of(context).textTheme.titleMedium,
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
