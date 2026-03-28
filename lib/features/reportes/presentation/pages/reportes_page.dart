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

  List<Movimiento> _filterMovimientos(List<Movimiento> movements) {
    return movements.where((m) {
      if (_startDate != null && m.fecha.isBefore(_startDate!)) return false;
      if (_endDate != null &&
          m.fecha.isAfter(_endDate!.add(const Duration(days: 1))))
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
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
        actions: [
          IconButton(
            onPressed: () => _selectDateRange(context),
            icon: const Icon(Icons.date_range),
            tooltip: 'Filtrar por fecha',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildKpiSection(),
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
                _buildResumenTab(),
                _buildMovimientosTab(),
                _buildInventarioTab(),
                _buildClientesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiSection() {
    return Consumer3<
      MovimientosViewModel,
      InventarioViewModel,
      ClientesViewModel
    >(
      builder: (context, movVM, invVM, cliVM, child) {
        final filteredMovs = _filterMovimientos(movVM.items);
        final totalIngresos = filteredMovs
            .where((m) => m.tipo == MovimientoType.ingreso)
            .fold(0.0, (sum, m) => sum + m.monto);
        final totalEgresos = filteredMovs
            .where((m) => m.tipo == MovimientoType.egreso)
            .fold(0.0, (sum, m) => sum + m.monto);
        final balance = totalIngresos - totalEgresos;
        final productosBajoStock = invVM.productosConStockBajo.length;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FinancialSummaryHeader(
                totalIngresos: totalIngresos,
                totalEgresos: totalEgresos,
                balance: balance,
                title: 'Resumen\nFinanciero',
                onDateTap: () {
                  _selectDateRange(context);
                },
                startDate: _startDate,
                endDate: _endDate,
                isCurrency3: balance >= 0,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInsightCard(
                      label: 'Stock Bajo',
                      value: productosBajoStock.toString(),
                      icon: Icons.warning_amber_rounded,
                      color: productosBajoStock > 0
                          ? AppTheme.errorColor
                          : AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInsightCard(
                      label: 'Deuda Clientes',
                      value: NumberFormatter.formatCompact(cliVM.totalDeuda),
                      icon: Icons.people_outline,
                      color: cliVM.totalDeuda > 0
                          ? AppTheme.errorColor
                          : AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  Widget _buildResumenTab() {
    return Consumer3<
      MovimientosViewModel,
      InventarioViewModel,
      ClientesViewModel
    >(
      builder: (context, movVM, invVM, cliVM, child) {
        final filteredMovs = _filterMovimientos(movVM.items);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Resumen del Período'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow(
                      'Total Movimientos',
                      filteredMovs.length.toString(),
                    ),
                    _buildSummaryRow(
                      'Ingresos',
                      filteredMovs
                          .where((m) => m.tipo == MovimientoType.ingreso)
                          .length
                          .toString(),
                    ),
                    _buildSummaryRow(
                      'Egresos',
                      filteredMovs
                          .where((m) => m.tipo == MovimientoType.egreso)
                          .length
                          .toString(),
                    ),
                    _buildSummaryRow(
                      'Actividades',
                      filteredMovs
                          .where((m) => m.tipo == MovimientoType.actividad)
                          .length
                          .toString(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Inventario'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow(
                      'Total Productos',
                      invVM.productos.length.toString(),
                    ),
                    _buildSummaryRow(
                      'Stock Total',
                      invVM.totalProductos.toString(),
                    ),
                    _buildSummaryRow(
                      'Valor Inventario',
                      NumberFormatter.formatCurrency(
                        invVM.valorTotalInventario,
                      ),
                    ),
                    _buildSummaryRow(
                      'Productos Bajo Stock',
                      invVM.productosConStockBajo.length.toString(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Clientes'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow(
                      'Total Clientes',
                      cliVM.totalClientes.toString(),
                    ),
                    _buildSummaryRow(
                      'Con Deuda',
                      cliVM.clientesConDeuda.toString(),
                    ),
                    _buildSummaryRow(
                      'Deuda Total',
                      NumberFormatter.formatCurrency(cliVM.totalDeuda),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMovimientosTab() {
    return Consumer<MovimientosViewModel>(
      builder: (context, movVM, child) {
        final filteredMovs = _filterMovimientos(movVM.items)
          ..sort((a, b) => b.fecha.compareTo(a.fecha));

        if (filteredMovs.isEmpty) {
          return const Center(
            child: Text('No hay movimientos en este período'),
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
                  NumberFormatter.formatCurrency(mov.monto),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getTipoColor(mov.tipo),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInventarioTab() {
    return Consumer<InventarioViewModel>(
      builder: (context, invVM, child) {
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
                subtitle: Text('Stock: ${prod.cantidad} | ${prod.categoria}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormatter.formatCurrency(prod.precio),
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
      },
    );
  }

  Widget _buildClientesTab() {
    return Consumer<ClientesViewModel>(
      builder: (context, cliVM, child) {
        final clientes = cliVM.clientes;

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
                subtitle: Text(cliente.telefono),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormatter.formatCurrency(cliente.saldoPendiente),
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
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
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
        return AppTheme.secondaryColor;
      case MovimientoType.egreso:
        return AppTheme.errorColor;
      case MovimientoType.actividad:
        return AppTheme.primaryColor;
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
}
