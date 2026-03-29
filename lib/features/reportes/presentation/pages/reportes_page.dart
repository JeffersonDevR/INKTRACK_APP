import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/widgets/financial_summary_header.dart';
import 'package:InkTrack/core/utils/number_formatter.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _startDate = DateTime.now().subtract(const Duration(days: 30));
    _endDate = DateTime.now();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Movimiento> _filterMovimientos(List<Movimiento> movements, MovimientosViewModel movVM) {
    return movements.where((m) {
      if (movVM.startDateFilter != null && m.fecha.isBefore(movVM.startDateFilter!)) return false;
      if (movVM.endDateFilter != null &&
          m.fecha.isAfter(movVM.endDateFilter!.add(const Duration(days: 1))))
        return false;
      return true;
    }).toList();
  }

  Future<void> _selectDateRange(BuildContext ctx) async {
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: _startDate ?? now.subtract(const Duration(days: 30)),
      end: _endDate ?? now,
    );

    final picked = await showDateRangePicker(
      context: ctx,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: initialRange,
    );

    if (picked != null) {
      context.read<MovimientosViewModel>().setDateFilter(picked.start, picked.end);
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildKpiSection();
  }

  Widget _buildKpiSection() {
    return Consumer3<
      MovimientosViewModel,
      InventarioViewModel,
      ClientesViewModel
    >(
      builder: (context, movVM, invVM, cliVM, child) {
        final filteredMovs = _filterMovimientos(movVM.items, movVM);
        final totalIngresos = filteredMovs
            .where((m) => m.tipo == MovimientoType.ingreso)
            .fold(0.0, (sum, m) => sum + m.monto);
        final totalEgresos = filteredMovs
            .where((m) => m.tipo == MovimientoType.egreso)
            .fold(0.0, (sum, m) => sum + m.monto);
        
        final summaryHeader = FinancialSummaryHeader(
          title: 'Resumen\nFinanciero',
          totalIngresos: totalIngresos,
          totalEgresos: totalEgresos,
          balance: totalIngresos - totalEgresos,
          startDate: movVM.startDateFilter,
          endDate: movVM.endDateFilter,
          onDateTap: () => _selectDateRange(context),
        );
        final kpiCards = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            children: [
              _buildInsightCard(
                label: 'Ingresos',
                value: NumberFormatter.formatCompact(totalIngresos),
                icon: Icons.trending_up,
                color: AppTheme.successColor,
              ),
              const SizedBox(width: 12),
              _buildInsightCard(
                label: 'Egresos',
                value: NumberFormatter.formatCompact(totalEgresos),
                icon: Icons.trending_down,
                color: AppTheme.errorColor,
              ),
              const SizedBox(width: 12),
              _buildInsightCard(
                label: 'Balance',
                value: NumberFormatter.formatCompact(totalIngresos - totalEgresos),
                icon: Icons.account_balance_wallet,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 12),
              _buildInsightCard(
                label: 'Bajo Stock',
                value: invVM.productosConStockBajo.length.toString(),
                icon: Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
            ],
          ),
        );

        return Column(
          children: [
            summaryHeader,
            kpiCards,
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Resumen'),
                Tab(text: 'Movimientos'),
                Tab(text: 'Inventario'),
                Tab(text: 'Clientes'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildResumenTab(movVM, invVM, cliVM),
                  _buildMovimientosTab(movVM),
                  _buildInventarioTab(invVM),
                  _buildClientesTab(movVM, cliVM),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInsightCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _getCategoryData(List<Movimiento> movs) {
    final Map<String, double> data = {};
    for (var m in movs.where((m) => m.tipo == MovimientoType.ingreso)) {
      final cat = m.categoria ?? 'Sin Categoría';
      data[cat] = (data[cat] ?? 0) + m.monto;
    }
    return data;
  }

  Map<String, double> _getCustomerData(List<Movimiento> movs) {
    final Map<String, double> data = {};
    for (var m in movs.where((m) => m.tipo == MovimientoType.ingreso && m.clienteId != null)) {
      final cid = m.clienteId!;
      data[cid] = (data[cid] ?? 0) + m.monto;
    }
    return data;
  }

  Widget _buildResumenTab(
    MovimientosViewModel movVM,
    InventarioViewModel invVM,
    ClientesViewModel cliVM,
  ) {
    final filteredMovs = _filterMovimientos(movVM.items, movVM);
        final categoryData = _getCategoryData(filteredMovs);
        final customerData = _getCustomerData(filteredMovs);
        
        // Sort customers by spending
        final sortedCustomers = customerData.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Distribución por Categoría'),
            const SizedBox(height: 12),
            if (categoryData.isEmpty)
              const Center(child: Text('No hay datos de ventas en este período'))
            else
              AspectRatio(
                aspectRatio: 1.5,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                    sections: categoryData.entries.map((e) {
                      final index = categoryData.keys.toList().indexOf(e.key);
                      final totalIncome = filteredMovs.where((m) => m.tipo == MovimientoType.ingreso).fold(0.0, (sum, m) => sum + m.monto);
                      final percentage = totalIncome > 0 ? (e.value / totalIncome * 100) : 0.0;
                      
                      return PieChartSectionData(
                        color: Colors.primaries[index % Colors.primaries.length],
                        value: e.value,
                        title: '${percentage.toStringAsFixed(0)}%',
                        radius: 50,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categoryData.entries.map((e) {
                final index = categoryData.keys.toList().indexOf(e.key);
                return _buildCategoryLegend(
                  e.key,
                  Colors.primaries[index % Colors.primaries.length],
                );
              }).toList().cast<Widget>(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Top Clientes (LTV)'),
            const SizedBox(height: 12),
            if (sortedCustomers.isEmpty)
              const Text('No hay datos de clientes')
            else
              ...sortedCustomers.take(5).map((e) {
                final cliente = cliVM.items.cast<Cliente?>().firstWhere(
                  (c) => c?.id == e.key,
                  orElse: () => null,
                );
                
                final nombre = cliente?.nombre ?? 'Cliente Desconocido';
                final idStr = cliente?.id ?? e.key;
                
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                    child: Text(nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                      style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('ID: ${idStr.length > 8 ? idStr.substring(0, 8) : idStr}'),
                  trailing: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Text(
                      NumberFormatter.formatCompact(e.value),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryColor,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }),
          ],
        );
  }

  Widget _buildMovimientosTab(MovimientosViewModel movVM) {
    final filteredMovs = movVM.filteredItems;

    if (filteredMovs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history_rounded, size: 64, color: AppTheme.textSecondary),
            const SizedBox(height: 16),
            const Text(
              'No hay movimientos en este período',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => movVM.clearDateFilter(),
              icon: const Icon(Icons.filter_alt_off_rounded),
              label: const Text('Limpiar Filtros'),
            ),
          ],
        ),
      );
    }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredMovs.length,
          itemBuilder: (context, index) {
            final mov = filteredMovs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getTipoColor(mov.tipo).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTipoIcon(mov.tipo),
                    color: _getTipoColor(mov.tipo),
                  ),
                ),
                title: Text(mov.concepto),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(mov.fecha),
                ),
                trailing: Text(
                  NumberFormatter.formatCompact(mov.monto),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getTipoColor(mov.tipo),
                  ),
                ),
              ),
            );
          },
        );
  }

  Widget _buildInventarioTab(InventarioViewModel invVM) {
    final productos = invVM.productos;

        if (productos.isEmpty) {
          return const Center(child: Text('No hay productos'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productos.length,
          itemBuilder: (context, index) {
            final prod = productos[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        (prod.stockBajo
                                ? AppTheme.errorColor
                                : AppTheme.primaryColor)
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    prod.stockBajo ? Icons.warning : Icons.inventory_2,
                    color: prod.stockBajo
                        ? AppTheme.errorColor
                        : AppTheme.primaryColor,
                  ),
                ),
                title: Text(prod.nombre),
                subtitle: Text('Stock: ${prod.cantidad}${prod.categoria != null ? ' | ${prod.categoria}' : ''}'),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormatter.formatCompact(prod.precio),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (prod.stockBajo)
                      const Text(
                        'BAJO',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
  }

  Widget _buildClientesTab(MovimientosViewModel movVM, ClientesViewModel cliVM) {
    final clientes = cliVM.items;

        if (clientes.isEmpty) {
          return const Center(child: Text('No hay clientes'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: clientes.length,
          itemBuilder: (context, index) {
            final cliente = clientes[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        (cliente.saldoPendiente > 0
                                ? AppTheme.errorColor
                                : AppTheme.secondaryColor)
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person,
                    color: cliente.saldoPendiente > 0
                        ? AppTheme.errorColor
                        : AppTheme.secondaryColor,
                  ),
                ),
                title: Text(cliente.nombre),
                subtitle: Text(cliente.telefono ?? ''),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormatter.formatCompact(cliente.saldoPendiente),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cliente.saldoPendiente > 0
                            ? AppTheme.errorColor
                            : AppTheme.secondaryColor,
                      ),
                    ),
                    if (cliente.esFiado)
                      const Text(
                        'FIADO',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.tertiaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getTipoColor(MovimientoType tipo) {
    switch (tipo) {
      case MovimientoType.ingreso:
        return AppTheme.successColor;
      case MovimientoType.egreso:
        return AppTheme.errorColor;
      case MovimientoType.actividad:
        return AppTheme.tertiaryColor;
    }
  }

  IconData _getTipoIcon(MovimientoType tipo) {
    switch (tipo) {
      case MovimientoType.ingreso:
        return Icons.arrow_downward;
      case MovimientoType.egreso:
        return Icons.arrow_upward;
      case MovimientoType.actividad:
        return Icons.sync;
    }
  }

  Widget _buildCategoryLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }
}
