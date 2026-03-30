import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/input_formatters.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';

class PagoDialog extends StatefulWidget {
  final Cliente cliente;

  const PagoDialog({super.key, required this.cliente});

  @override
  State<PagoDialog> createState() => _PagoDialogState();
}

class _PagoDialogState extends State<PagoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _montoController;

  @override
  void initState() {
    super.initState();
    _montoController = TextEditingController(
      text: NumberFormatter.formatCurrency(
        widget.cliente.saldoPendiente,
      ).replaceAll('\$', ''),
    );
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  void _registrarPago() {
    if (!_formKey.currentState!.validate()) return;

    final monto = NumberFormatter.parseAmount(_montoController.text);

    context.read<ClientesViewModel>().registrarPago(
      widget.cliente.id,
      monto,
      context.read<MovimientosViewModel>(),
    );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pago de ${NumberFormatter.formatCurrency(monto)} registrado',
        ),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Registrar pago: ${widget.cliente.nombre}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo pendiente: ${NumberFormatter.formatCurrency(widget.cliente.saldoPendiente)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _montoController,
              decoration: const InputDecoration(
                labelText: 'Monto a pagar',
                prefixText: '\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [InputFormatters.decimal],
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese el monto';
                }
                final number = NumberFormatter.parseAmount(value);
                if (number <= 0) {
                  return 'Monto inválido';
                }
                if (number > widget.cliente.saldoPendiente) {
                  return 'El monto no puede exceder el saldo';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _registrarPago,
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
