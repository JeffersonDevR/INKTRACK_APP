import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/excel_import_service.dart';
import 'package:InkTrack/core/widgets/import_preview_page.dart';

/// Runs the full import flow for a given module:
/// 1. Pick file (XLSX/CSV)
/// 2. Parse with ExcelImportService
/// 3. Check required columns
/// 4. Show preview page
/// 5. On confirm → run batchImport in transaction
///
/// [moduleName] - display name like "Clientes"
/// [requiredColumns] - list of required column names
/// [validate] - function that validates parsed rows and returns typed result
/// [batchImport] - function that does batch insert in a transaction
/// [context] - BuildContext for navigation
/// [title] - optional custom title for the preview page
/// [db] - AppDatabase instance for batch insert
Future<void> runImportFlow<T>({
  required BuildContext context,
  required String moduleName,
  required List<String> requiredColumns,
  required ValidatedImportResult<T> Function(ImportResult result) validate,
  required Future<void> Function(AppDatabase db, List<T> items) batchImport,
  required AppDatabase db,
  String? title,
}) async {
  // Step 1: Pick file
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv', 'xlsx'],
  );

  if (result == null || result.files.isEmpty) return;

  final file = result.files.first;
  if (file.path == null) return;

  // Step 2: Parse
  final ImportResult parsed;
  try {
    if (file.path!.endsWith('.xlsx')) {
      final bytes = await File(file.path!).readAsBytes();
      parsed = ExcelImportService.parseXlsx(bytes);
    } else {
      final content = await File(file.path!).readAsString();
      parsed = ExcelImportService.parseCsv(content);
    }
  } catch (e) {
    if (context.mounted) {
      _showErrorSnackBar(context, 'Error al leer el archivo: $e');
    }
    return;
  }

  if (!context.mounted) return;

  // Step 3: Check required columns
  if (parsed.columns.isEmpty) {
    _showErrorSnackBar(context, 'El archivo no contiene datos válidos.');
    return;
  }

  final missingColumns = ExcelImportService.checkRequiredColumns(
    parsed,
    requiredColumns,
  );
  if (missingColumns.isNotEmpty) {
    _showErrorSnackBar(
      context,
      'Faltan columnas requeridas: ${missingColumns.join(", ")}',
    );
    return;
  }

  if (parsed.rows.isEmpty) {
    _showErrorSnackBar(context, 'El archivo no contiene filas de datos.');
    return;
  }

  // Step 4: Validate rows
  final validated = validate(parsed);
  final allErrors = <String>[
    ...parsed.errors,
    ...validated.errors.map((e) => 'Fila ${e.rowIndex}: ${e.message}'),
  ];

  // Step 5: Show preview
  final previewResult = await Navigator.push<ImportPreviewResult>(
    context,
    MaterialPageRoute(
      builder: (_) => ImportPreviewPage(
        parsedData: parsed,
        moduleName: moduleName,
        errors: allErrors,
        title: title,
      ),
    ),
  );

  if (previewResult == null || !previewResult.confirmed) return;
  if (validated.validRows.isEmpty) {
    if (context.mounted) {
      _showErrorSnackBar(context, 'No hay datos válidos para importar.');
    }
    return;
  }

  // Step 6: Batch import in transaction
  if (!context.mounted) return;
  try {
    await batchImport(db, validated.validRows);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${validated.validRows.length} $moduleName importado(s) correctamente.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      _showErrorSnackBar(
        context,
        'Error al importar: La operación fue revertida. $e',
      );
    }
  }
}

void _showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
    ),
  );
}
