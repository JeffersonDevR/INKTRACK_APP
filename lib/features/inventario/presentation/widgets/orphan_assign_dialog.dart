import 'package:flutter/material.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/presentation/pages/producto_form_page.dart';

enum OrphanAssignAction {
  assignExisting,
  createNew,
  cancel,
}

Future<OrphanAssignAction?> showOrphanAssignDialog(
  BuildContext context, {
  required String codigo,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<OrphanAssignAction>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.orphanCodeTitle),
      content: Text(l10n.orphanCodeMessage(codigo)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, OrphanAssignAction.cancel),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, OrphanAssignAction.assignExisting),
          child: Text(l10n.orphanAssignExistingAction),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, OrphanAssignAction.createNew),
          child: Text(l10n.orphanCreateNewAction),
        ),
      ],
    ),
  );
}

Future<void> handleOrphanCode(
  BuildContext context, {
  required String codigo,
  required void Function(Producto producto) onProductAssigned,
}) async {
  final action = await showOrphanAssignDialog(context, codigo: codigo);

  if (action == null || action == OrphanAssignAction.cancel) return;
  if (!context.mounted) return;

  switch (action) {
    case OrphanAssignAction.assignExisting:
      final producto = await _showProductPicker(context);
      if (producto != null && context.mounted) {
        final updated = producto.copyWith(codigoBarras: codigo);
        onProductAssigned(updated);
      }
      break;
    case OrphanAssignAction.createNew:
      if (context.mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductoFormPage(initialCodigoBarras: codigo),
          ),
        );
      }
      break;
    case OrphanAssignAction.cancel:
      break;
  }
}

Future<Producto?> _showProductPicker(BuildContext context) async {
  return showDialog<Producto>(
    context: context,
    builder: (ctx) => const _ProductPickerDialog(),
  );
}

class _ProductPickerDialog extends StatelessWidget {
  const _ProductPickerDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar producto'),
      content: const SizedBox(
        width: double.maxFinite,
        child: Text('Lista de productos disponibles'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
