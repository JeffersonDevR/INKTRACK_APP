import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';

class ImportRow {
  final int index;
  final Map<String, String?> data;

  ImportRow({required this.index, required this.data});

  String? operator [](String key) => data[key];

  @override
  String toString() => 'ImportRow($index: $data)';
}

class ImportResult {
  final List<String> columns;
  final List<ImportRow> rows;
  final List<String> errors;

  ImportResult({
    required this.columns,
    required this.rows,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
  int get totalRows => rows.length;
  bool get isEmpty => rows.isEmpty;
}

/// Represents a validation error for a specific row.
class RowValidationError {
  final int rowIndex;
  final String message;

  RowValidationError({required this.rowIndex, required this.message});
}

/// Represents validated data with typed rows and per-row errors.
class ValidatedImportResult<T> {
  final List<T> validRows;
  final List<RowValidationError> errors;

  ValidatedImportResult({required this.validRows, required this.errors});

  bool get hasErrors => errors.isNotEmpty;
  int get validCount => validRows.length;
}

class ExcelImportService {
  /// Parses an XLSX file from bytes.
  static ImportResult parseXlsx(Uint8List bytes) {
    final excel = Excel.decodeBytes(bytes);
    final errors = <String>[];

    if (excel.sheets.isEmpty) {
      return ImportResult(
        columns: [],
        rows: [],
        errors: ['El archivo no contiene hojas de cálculo'],
      );
    }

    final sheet = excel.sheets.values.first;
    final rows = <ImportRow>[];

    if (sheet.rows.isEmpty) {
      return ImportResult(
        columns: [],
        rows: [],
        errors: ['El archivo está vacío'],
      );
    }

    // First row is the header
    final headerRow = sheet.rows.first;
    final columns = headerRow.map((cell) {
      return cell?.value?.toString() ?? '';
    }).toList();

    if (columns.isEmpty || columns.every((c) => c.isEmpty)) {
      return ImportResult(
        columns: [],
        rows: [],
        errors: ['No se encontraron encabezados en el archivo'],
      );
    }

    // Normalize column names: lowercase + trim
    final normalizedColumns = columns.map((c) => c.trim().toLowerCase()).toList();

    // Data rows
    for (var i = 1; i < sheet.rows.length; i++) {
      final row = sheet.rows[i];
      final data = <String, String?>{};
      for (var j = 0; j < normalizedColumns.length; j++) {
        if (j < row.length) {
          final cell = row[j];
          data[normalizedColumns[j]] = cell?.value?.toString().trim();
        } else {
          data[normalizedColumns[j]] = null;
        }
      }
      rows.add(ImportRow(index: i - 1, data: data));
    }

    return ImportResult(columns: columns, rows: rows, errors: errors);
  }

  /// Parses a CSV string.
  static ImportResult parseCsv(String content) {
    final errors = <String>[];
    final lines = const LineSplitter().convert(content);

    if (lines.isEmpty || (lines.length == 1 && lines[0].trim().isEmpty)) {
      return ImportResult(
        columns: [],
        rows: [],
        errors: ['El archivo está vacío'],
      );
    }

    final parsedLines = lines.map(_parseCsvLine).toList();

    // First line is header
    if (parsedLines.first.isEmpty) {
      return ImportResult(
        columns: [],
        rows: [],
        errors: ['No se encontraron encabezados en el archivo'],
      );
    }

    final columns = parsedLines.first;
    final normalizedColumns = columns.map((c) => c.trim().toLowerCase()).toList();
    final rows = <ImportRow>[];

    for (var i = 1; i < parsedLines.length; i++) {
      final line = parsedLines[i];
      if (line.every((c) => c.trim().isEmpty)) continue;

      final data = <String, String?>{};
      for (var j = 0; j < normalizedColumns.length; j++) {
        data[normalizedColumns[j]] = j < line.length ? line[j].trim() : null;
      }
      rows.add(ImportRow(index: i - 1, data: data));
    }

    return ImportResult(columns: columns, rows: rows, errors: errors);
  }

  /// Parses a CSV line handling quoted fields.
  static List<String> _parseCsvLine(String line) {
    final result = <String>[];
    var current = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          current.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    result.add(current.toString());
    return result;
  }

  /// Parses a file by path (supports .xlsx and .csv).
  static Future<ImportResult> parseFile(String filePath) async {
    final file = File(filePath);
    final isXlsx = filePath.endsWith('.xlsx') || filePath.endsWith('.xls');

    if (isXlsx) {
      final bytes = await file.readAsBytes();
      return parseXlsx(bytes);
    } else {
      final content = await file.readAsString(encoding: utf8);
      return parseCsv(content);
    }
  }

  /// Parses bytes with explicit format flag.
  static Future<ImportResult> parseBytes(
    Uint8List bytes, {
    required bool isXlsx,
  }) {
    if (isXlsx) {
      return Future.value(parseXlsx(bytes));
    } else {
      final content = utf8.decode(bytes);
      return Future.value(parseCsv(content));
    }
  }

  /// Validates that all required columns exist in the parsed result.
  static List<String> checkRequiredColumns(
    ImportResult result,
    List<String> requiredColumns,
  ) {
    final normalizedColumns = result.columns
        .map((c) => c.trim().toLowerCase())
        .toSet();
    final normalizedRequired =
        requiredColumns.map((c) => c.trim().toLowerCase()).toSet();

    return normalizedRequired
        .where((req) => !normalizedColumns.contains(req))
        .map<String>((req) {
          final originalIndex = requiredColumns
              .indexWhere((c) => c.trim().toLowerCase() == req);
          return requiredColumns[originalIndex];
        })
        .toList();
  }

  /// Checks if there are any completely empty rows.
  static List<int> findEmptyRows(ImportResult result) {
    final emptyIndexes = <int>[];
    for (final row in result.rows) {
      if (row.data.values.every((v) => v == null || v.trim().isEmpty)) {
        emptyIndexes.add(row.index);
      }
    }
    return emptyIndexes;
  }
}
