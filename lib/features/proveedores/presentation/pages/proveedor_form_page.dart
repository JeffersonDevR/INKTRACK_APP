import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:InkTrack/features/proveedores/presentation/viewmodels/proveedores_viewmodel.dart';
import 'package:InkTrack/features/locales/presentation/viewmodels/locales_viewmodel.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/proveedores/data/models/proveedor.dart';
import 'package:InkTrack/core/input_formatters.dart';

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
  final List<String> _diasVisita = [];

  List<String> _diasSemana(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.lunes,
      l10n.martes,
      l10n.miercoles,
      l10n.jueves,
      l10n.viernes,
      l10n.sabado,
      l10n.domingo,
    ];
  }

  @override
  void initState() {
    super.initState();
    if (widget.proveedor != null) {
      _nombreController.text = widget.proveedor!.nombre;
      _telefonoController.text = widget.proveedor!.telefono;
      _diasVisita.addAll(widget.proveedor!.diasVisita);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.proveedor == null ? l10n.nuevoProveedor : l10n.editarProveedor,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: l10n.nombre,
                  border: const OutlineInputBorder(),
                  hintText: l10n.ejemploNombre,
                  counterText: '',
                ),
                maxLength: 40,
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.diasVisita,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _diasSemana(context).map((dia) {
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
                    widget.proveedor == null ? l10n.guardar : l10n.actualizar,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProveedor() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<ProveedoresViewModel>();
      final localesVM = context.read<LocalesViewModel>();

      try {
        if (widget.proveedor == null) {
          await viewModel.agregar(
            nombre: _nombreController.text,
            telefono: _telefonoController.text,
            diasVisita: _diasVisita,
            movimientosVM: context.read<MovimientosViewModel>(),
            localId: localesVM.localIdSeleccionado,
          );
        } else {
          await viewModel.editar(
            id: widget.proveedor!.id,
            nombre: _nombreController.text,
            telefono: _telefonoController.text,
            diasVisita: _diasVisita,
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
