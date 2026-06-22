import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/core/input_formatters.dart';

class ClienteFormPage extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormPage({super.key, this.cliente});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _nombreController.text = widget.cliente!.nombre;
      _telefonoController.text = widget.cliente!.telefono;
      _emailController.text = widget.cliente!.email ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cliente == null ? l10n.nuevoCliente : l10n.editarCliente,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: l10n.nombre,
                  border: const OutlineInputBorder(),
                  hintText: l10n.ejemploNombre,
                  counterText: '',
                ),
                maxLength: 30,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.ingreseNombre;
                  }
                  if (value.length < 2) {
                    return l10n.minimo2Caracteres;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(
                  labelText: l10n.telefono,
                  border: const OutlineInputBorder(),
                  hintText: l10n.ejemploTelefono,
                  helperText: l10n.digitos10SinEspacios,
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.ingreseTelefono;
                  }
                  if (value.length != 10) {
                    return l10n.telefono10Digitos;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  border: const OutlineInputBorder(),
                  hintText: l10n.ejemploEmail,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.ingreseEmail;
                  }
                  if (!value.contains('@')) {
                    return l10n.ingreseEmailValido;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveCliente,
                child: Text(
                  widget.cliente == null ? l10n.guardar : l10n.actualizar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCliente() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<ClientesViewModel>();

      try {
        if (widget.cliente == null) {
          final localesVM = context.read<LocalesViewModel>();
          await viewModel.agregar(
            nombre: _nombreController.text,
            telefono: _telefonoController.text,
            email: _emailController.text,
            esFiado: false,
            localId: localesVM.localIdSeleccionado,
            movimientosVM: context.read<MovimientosViewModel>(),
          );
        } else {
          await viewModel.editar(
            id: widget.cliente!.id,
            nombre: _nombreController.text,
            telefono: _telefonoController.text,
            email: _emailController.text,
            esFiado: widget.cliente!.esFiado,
          );
        }
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}
