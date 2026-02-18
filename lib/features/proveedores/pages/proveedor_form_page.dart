import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/proveedores_viewmodel.dart';
import '../models/proveedor.dart';
import '../../../core/input_formatters.dart';

class ProveedorFormPage extends StatefulWidget {
  final Proveedor? proveedor;

  const ProveedorFormPage({super.key, this.proveedor});

  @override
  State<ProveedorFormPage> createState() => _ProveedorFormPageState();
}

class _ProveedorFormPageState extends State<ProveedorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _diasParaLlegarController = TextEditingController();
  final List<String> _diasVisita = [];

  final List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.proveedor != null) {
      _nombreController.text = widget.proveedor!.nombre;
      _telefonoController.text = widget.proveedor!.telefono;
      _diasParaLlegarController.text = widget.proveedor!.diasParaLlegar
          .toString();
      _diasVisita.addAll(widget.proveedor!.diasVisita);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _diasParaLlegarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.proveedor == null ? 'Nuevo Proveedor' : 'Editar Proveedor',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
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
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diasParaLlegarController,
                decoration: const InputDecoration(
                  labelText: 'Días para llegar',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [InputFormatters.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los días';
                  }
                  final dias = int.tryParse(value);
                  if (dias == null || dias < 0) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Días de visita',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _diasSemana.map((dia) {
                  final isSelected = _diasVisita.contains(dia);
                  return FilterChip(
                    label: Text(dia),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _diasVisita.add(dia);
                        } else {
                          _diasVisita.remove(dia);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProveedor,
                  child: Text(
                    widget.proveedor == null ? 'Guardar' : 'Actualizar',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProveedor() {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<ProveedoresViewModel>();

      if (widget.proveedor == null) {
        viewModel.agregar(
          nombre: _nombreController.text,
          telefono: _telefonoController.text,
          diasParaLlegar: int.parse(_diasParaLlegarController.text),
          diasVisita: _diasVisita,
        );
      } else {
        viewModel.editar(
          id: widget.proveedor!.id,
          nombre: _nombreController.text,
          telefono: _telefonoController.text,
          diasParaLlegar: int.parse(_diasParaLlegarController.text),
          diasVisita: _diasVisita,
        );
      }

      Navigator.pop(context);
    }
  }
}
