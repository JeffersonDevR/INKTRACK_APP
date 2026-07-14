import 'package:flutter/material.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

class CreditLimitDialog extends StatefulWidget {
  final double actual;
  final double nuevo;
  final double limite;
  final Future<bool> Function(String pin) onVerifyPin;
  final VoidCallback onOverrideSuccess;

  const CreditLimitDialog({
    super.key,
    required this.actual,
    required this.nuevo,
    required this.limite,
    required this.onVerifyPin,
    required this.onOverrideSuccess,
  });

  @override
  State<CreditLimitDialog> createState() => _CreditLimitDialogState();
}

class _CreditLimitDialogState extends State<CreditLimitDialog> {
  final _pinController = TextEditingController();
  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleOverride() async {
    final pin = _pinController.text.trim();
    if (pin.isEmpty) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final isValid = await widget.onVerifyPin(pin);
    if (isValid) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onOverrideSuccess();
      }
    } else {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _errorMessage = 'PIN incorrecto';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final message = l10n.creditLimitExceededMessage(
      widget.actual.toStringAsFixed(2),
      widget.nuevo.toStringAsFixed(2),
      widget.limite.toStringAsFixed(2),
    );

    return AlertDialog(
      title: Text(l10n.creditLimitExceededTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(message),
            const SizedBox(height: 16),
            Text(
              l10n.creditLimitContinueAnyway,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: 'PIN de Gerente',
                errorText: _errorMessage,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        ElevatedButton(
          onPressed: _isVerifying ? null : _handleOverride,
          child: _isVerifying
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Continuar'),
        ),
      ],
    );
  }
}
