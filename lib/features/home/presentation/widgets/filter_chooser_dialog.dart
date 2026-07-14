// lib/features/home/presentation/widgets/filter_chooser_dialog.dart
import 'package:intl/intl.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:InkTrack/core/services/reports/report_filters.dart';

class FilterChooserDialog extends StatefulWidget {
  final ReportFilters initialFilters;

  const FilterChooserDialog({
    Key? key,
    this.initialFilters = const ReportFilters(),
  }) : super(key: key);

  @override
  State<FilterChooserDialog> createState() => _FilterChooserDialogState();
}

class _FilterChooserDialogState extends State<FilterChooserDialog> {
  late bool _soloDeudores;
  late bool _abonosDelMes;
  late bool _topVendidos;
  late bool _inventarioCriticoValorizado;
  late bool _incluirCosto;
  int? _topN;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _soloDeudores = widget.initialFilters.soloDeudores;
    _abonosDelMes = widget.initialFilters.abonosDelMes;
    _topVendidos = widget.initialFilters.topVendidos;
    _inventarioCriticoValorizado =
        widget.initialFilters.inventarioCriticoValorizado;
    _incluirCosto = widget.initialFilters.incluirCosto;
    _topN = widget.initialFilters.topN ?? 10;
    _startDate = widget.initialFilters.startDate;
    _endDate = widget.initialFilters.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.reportFiltersTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text(l10n.filterOnlyDebtors),
              value: _soloDeudores,
              onChanged: (val) => setState(() => _soloDeudores = val ?? false),
            ),
            CheckboxListTile(
              title: Text(l10n.filterAbonosOfMonth),
              value: _abonosDelMes,
              onChanged: (val) => setState(() => _abonosDelMes = val ?? false),
            ),
            CheckboxListTile(
              title: Text(l10n.filterTopSold),
              value: _topVendidos,
              onChanged: (val) => setState(() => _topVendidos = val ?? false),
            ),
            CheckboxListTile(
              title: Text(l10n.filterCriticalInventoryValorized),
              value: _inventarioCriticoValorizado,
              onChanged: (val) =>
                  setState(() => _inventarioCriticoValorizado = val ?? false),
            ),
            CheckboxListTile(
              title: Text(l10n.filterIncludeCost),
              value: _incluirCosto,
              onChanged: (val) => setState(() => _incluirCosto = val ?? false),
            ),
            if (_topVendidos)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Text(l10n.filterTopN(_topN ?? 10)),
                    Expanded(
                      child: Slider(
                        value: (_topN ?? 10).toDouble(),
                        min: 1,
                        max: 50,
                        divisions: 49,
                        label: _topN.toString(),
                        onChanged: (val) => setState(() => _topN = val.toInt()),
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(height: 24),
            // Start date picker
            ListTile(
              title: const Text('Desde'),
              subtitle: Text(
                _startDate != null
                    ? DateFormat('dd/MM/yyyy').format(_startDate!)
                    : 'Sin filtro',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_startDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _startDate = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        locale: const Locale('es'),
                      );
                      if (picked != null) {
                        setState(() => _startDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
            // End date picker
            ListTile(
              title: const Text('Hasta'),
              subtitle: Text(
                _endDate != null
                    ? DateFormat('dd/MM/yyyy').format(_endDate!)
                    : 'Sin filtro',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_endDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _endDate = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        locale: const Locale('es'),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelar),
        ),
        ElevatedButton(
          onPressed: () {
            final filters = ReportFilters(
              soloDeudores: _soloDeudores,
              abonosDelMes: _abonosDelMes,
              topVendidos: _topVendidos,
              inventarioCriticoValorizado: _inventarioCriticoValorizado,
              incluirCosto: _incluirCosto,
              topN: _topN,
              startDate: _startDate,
              endDate: _endDate,
            );
            Navigator.of(context).pop(filters);
          },
          child: const Text('Generar Reporte'), // For the test
        ),
      ],
    );
  }
}
