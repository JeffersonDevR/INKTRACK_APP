import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/input_formatters.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

class PagoDialog extends StatefulWidget {
  final Cliente cliente;
  final double? maxAmount;
  final String? conceptDetail;

  const PagoDialog({
    super.key,
    required this.cliente,
    this.maxAmount,
    this.conceptDetail,
  });

  @override
  State<PagoDialog> createState() => _PagoDialogState();
}

class _PagoDialogState extends State<PagoDialog> {
  double get _maxAmount {
    if (widget.maxAmount == null) {
      return widget.cliente.saldoPendiente;
    }
    return math.min(widget.maxAmount!, widget.cliente.saldoPendiente);
  }
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _montoController;
  bool _isLoading = false;

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
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final monto = NumberFormatter.parseAmount(_montoController.text);

    context.read<ClientesViewModel>().registrarPago(
      widget.cliente.id,
      monto,
      context.read<MovimientosViewModel>(),
      conceptoDetalle: widget.conceptDetail,
    );

    Navigator.pop(context);

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${l10n.abonoAgregado}: ${NumberFormatter.formatCurrency(monto)}',
        ),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text('${l10n.registrarPago}: ${widget.cliente.nombre}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.saldoPendiente}: ${NumberFormatter.formatCurrency(widget.cliente.saldoPendiente)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _montoController,
                decoration: InputDecoration(
                  labelText: l10n.montoAPagar,
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [InputFormatters.decimal],
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.ingreseMonto;
                  }
                  final number = NumberFormatter.parseAmount(value);
                  if (number <= 0) {
                    return l10n.montoInvalido;
                  }
                  if (number > _maxAmount) {
                    return l10n.montoInvalido;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancelar),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _registrarPago,
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.registrarPago),
        ),
      ],
    );
  }
}
