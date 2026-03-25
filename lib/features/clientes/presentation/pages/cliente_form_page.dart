import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
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
  bool _esFiado = false;

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _nombreController.text = widget.cliente!.nombre;
      _telefonoController.text = widget.cliente!.telefono;
      _emailController.text = widget.cliente!.email;
      _esFiado = widget.cliente!.esFiado;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cliente == null ? 'Nuevo Cliente' : 'Editar Cliente',
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
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  hintText: 'Ej. Juan Pérez',
                ),
                textCapitalization: TextCapitalization.words,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                  hintText: 'Ej. 1234567890',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [InputFormatters.phone],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'ejemplo@correo.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el email';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor ingrese un email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('¿Es Fiado?'),
                subtitle: const Text(
                  'Activar si este cliente tiene deudas pendientes',
                ),
                value: _esFiado,
                onChanged: (value) => setState(() => _esFiado = value),
                tileColor: Colors.grey.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveCliente,
                child: Text(widget.cliente == null ? 'Guardar' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCliente() {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<ClientesViewModel>();

      if (widget.cliente == null) {
        viewModel.agregar(
          nombre: _nombreController.text,
          telefono: _telefonoController.text,
          email: _emailController.text,
          esFiado: _esFiado,
          movimientosVM: context.read<MovimientosViewModel>(),
        );
      } else {
        viewModel.editar(
          id: widget.cliente!.id,
          nombre: _nombreController.text,
          telefono: _telefonoController.text,
          email: _emailController.text,
          esFiado: _esFiado,
        );
      }

      Navigator.pop(context);
    }
  }
}
