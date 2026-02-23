import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/movimiento.dart';
import '../viewmodels/movimientos_viewmodel.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/input_formatters.dart';

const String _kNewCategoryValue = '__new_category__';

class MovimientoFormPage extends StatefulWidget {
  final MovimientoType initialType;
  final Movimiento? movimiento;

  const MovimientoFormPage({
    super.key,
    this.initialType = MovimientoType.egreso,
    this.movimiento,
  });

  @override
  State<MovimientoFormPage> createState() => _MovimientoFormPageState();
}

class _MovimientoFormPageState extends State<MovimientoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late MovimientoType _tipo;
  final _montoController = TextEditingController();
  final _conceptoController = TextEditingController();
  String? _categoria;
  DateTime _fecha = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.movimiento != null) {
      _tipo = widget.movimiento!.tipo;
      _montoController.text = widget.movimiento!.monto.toString();
      _conceptoController.text = widget.movimiento!.concepto;
      _categoria = widget.movimiento!.categoria;
      _fecha = widget.movimiento!.fecha;
    } else {
      _tipo = widget.initialType;
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
    _conceptoController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final mov = Movimiento(
        id: widget.movimiento?.id ?? const Uuid().v4(),
        monto: double.parse(_montoController.text),
        fecha: _fecha,
        tipo: _tipo,
        concepto: _conceptoController.text,
        categoria: _categoria,
      );

      final viewModel = context.read<MovimientosViewModel>();
      if (widget.movimiento == null) {
        viewModel.add(mov);
      } else {
        viewModel.editar(widget.movimiento!.id, mov);
      }
      Navigator.pop(context);
    }
  }

  Future<String?> _showAddCategoryDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Categoría'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nombre de la categoría'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tipo == MovimientoType.ingreso ? 'Nuevo Ingreso' : 'Nuevo Egreso'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<MovimientoType>(
                segments: const [
                  ButtonSegment(
                    value: MovimientoType.ingreso,
                    label: Text('Ingreso'),
                    icon: Icon(Icons.add_circle_outline),
                  ),
                  ButtonSegment(
                    value: MovimientoType.egreso,
                    label: Text('Egreso'),
                    icon: Icon(Icons.remove_circle_outline),
                  ),
                ],
                selected: {_tipo},
                onSelectionChanged: (Set<MovimientoType> newSelection) {
                  setState(() {
                    _tipo = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _montoController,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixText: '\$ ',
                  hintText: '0.00',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [InputFormatters.decimal],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese un monto';
                  if (double.tryParse(value) == null) return 'Monto inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _conceptoController,
                decoration: const InputDecoration(
                  labelText: 'Concepto',
                  hintText: 'Ej. Venta de insumos',
                ),
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [InputFormatters.textOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese un concepto';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<MovimientosViewModel>(
                builder: (context, mvm, child) {
                  final categories = mvm.categorias;
                  return DropdownButtonFormField<String>(
                    initialValue: categories.contains(_categoria) ? _categoria : null,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: Icon(Icons.category_outlined),
                      hintText: 'Seleccione una categoría',
                    ),
                    items: [
                      ...categories.map(
                        (c) => DropdownMenuItem(value: c, child: Text(c)),
                      ),
                      const DropdownMenuItem(
                        value: _kNewCategoryValue,
                        child: Text('+ Nueva categoría'),
                      ),
                    ],
                    onChanged: (value) async {
                      if (value == _kNewCategoryValue) {
                        final newCat = await _showAddCategoryDialog();
                        if (newCat != null && newCat.isNotEmpty) {
                          mvm.agregarCategoria(newCat);
                          setState(() => _categoria = newCat);
                        }
                      } else {
                        setState(() => _categoria = value);
                      }
                    },
                    validator: (value) {
                      if (_categoria == null || _categoria!.isEmpty) {
                        return 'Seleccione o cree una categoría';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Fecha'),
                subtitle: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _fecha = picked;
                    });
                  }
                },
                trailing: const Icon(Icons.edit_calendar),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _tipo == MovimientoType.ingreso 
                      ? Colors.green.shade600 
                      : AppTheme.errorColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('GUARDAR', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
