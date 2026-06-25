import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/excel_import_service.dart';
import '../theme/app_theme.dart';

/// Result returned from the import preview page.
class ImportPreviewResult {
  final bool confirmed;
  final ImportResult parsedData;
  final String moduleName;

  ImportPreviewResult({
    required this.confirmed,
    required this.parsedData,
    required this.moduleName,
  });
}

class ImportPreviewPage extends StatelessWidget {
  final ImportResult parsedData;
  final String moduleName;
  final List<String> errors;
  final String? title;

  const ImportPreviewPage({
    super.key,
    required this.parsedData,
    required this.moduleName,
    this.errors = const [],
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayTitle = title ?? 'Importar $moduleName';

    return Scaffold(
      appBar: AppBar(
        title: Text(displayTitle),
        actions: [
          if (parsedData.rows.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  '${parsedData.rows.length} filas',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Error banner
          if (errors.isNotEmpty || parsedData.hasErrors)
            _ErrorBanner(
              errors: [...errors, ...parsedData.errors],
            ),

          // Summary card
          _SummaryCard(
            totalRows: parsedData.rows.length,
            columns: parsedData.columns.length,
            moduleName: moduleName,
          ),

          // Preview table
          Expanded(
            child: parsedData.rows.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 64,
                          color: isDark
                              ? AppTheme.darkTextTertiary
                              : AppTheme.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay datos para importar',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  )
                : _DataPreviewTable(
                    columns: parsedData.columns,
                    rows: parsedData.rows,
                  ),
          ),
        ],
      ),
      bottomNavigationBar: parsedData.rows.isNotEmpty && errors.isEmpty
          ? _BottomActions(
              onCancel: () => Navigator.pop(
                context,
                ImportPreviewResult(
                  confirmed: false,
                  parsedData: parsedData,
                  moduleName: moduleName,
                ),
              ),
              onConfirm: () => Navigator.pop(
                context,
                ImportPreviewResult(
                  confirmed: true,
                  parsedData: parsedData,
                  moduleName: moduleName,
                ),
              ),
            )
          : null,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final List<String> errors;

  const _ErrorBanner({required this.errors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppTheme.errorColor.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 20,
                color: AppTheme.errorColor,
              ),
              const SizedBox(width: 8),
              Text(
                '${errors.length} error(es) encontrado(s)',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.errorColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...errors.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 28),
                  Expanded(
                    child: Text(
                      '• $e',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppTheme.errorColor.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalRows;
  final int columns;
  final String moduleName;

  const _SummaryCard({
    required this.totalRows,
    required this.columns,
    required this.moduleName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : const Color(0xFFF1F5F9),
        ),
      ),
      child: Row(
        children: [
          _StatChip(
            icon: Icons.table_rows_rounded,
            label: 'Filas',
            value: '$totalRows',
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 16),
          _StatChip(
            icon: Icons.view_column_rounded,
            label: 'Columnas',
            value: '$columns',
            color: AppTheme.infoColor,
          ),
          const SizedBox(width: 16),
          _StatChip(
            icon: Icons.folder_outlined,
            label: 'Módulo',
            value: moduleName,
            color: AppTheme.successColor,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataPreviewTable extends StatelessWidget {
  final List<String> columns;
  final List<ImportRow> rows;

  const _DataPreviewTable({
    required this.columns,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Show max 50 rows in preview
    final previewRows = rows.take(50).toList();
    final hasMore = rows.length > 50;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark
                ? AppTheme.darkCard.withValues(alpha: 0.7)
                : AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Text(
                  '#',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? AppTheme.darkTextTertiary
                        : AppTheme.textTertiary,
                  ),
                ),
              ),
              ...columns.map(
                (col) => Expanded(
                  child: Text(
                    col,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppTheme.darkTextTertiary
                          : AppTheme.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Table rows
        ...previewRows.map(
          (row) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? AppTheme.darkBorder
                      : const Color(0xFFF1F5F9),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    '${row.index + 1}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.darkTextTertiary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
                ...columns.map(
                  (col) {
                    final value =
                        row.data[col.trim().toLowerCase()] ?? '';
                    return Expanded(
                      child: Text(
                        value,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: value.isEmpty
                              ? (isDark
                                  ? AppTheme.darkTextTertiary
                                  : AppTheme.textTertiary)
                              : (isDark
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.textPrimary),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '... y ${rows.length - 50} filas más',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _BottomActions({
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.upload_rounded, size: 20),
              label: const Text(
                'Confirmar e Importar',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
