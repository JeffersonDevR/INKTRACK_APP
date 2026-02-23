import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/movimiento.dart';
import '../viewmodels/movimientos_viewmodel.dart';
import 'movimiento_form_page.dart';
import '../../../core/theme/app_theme.dart';

class MovimientosPage extends StatelessWidget {
  const MovimientosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingresos / Egresos')),
      body: Consumer<MovimientosViewModel>(
        builder: (context, vm, child) {
          return Column(
            children: [
              _BalanceHeader(vm: vm),
              Expanded(
                child: vm.items.isEmpty
                    ? _EmptyMovimientos()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: vm.items.length,
                        itemBuilder: (context, index) {
                          final m = vm.items[vm.items.length - 1 - index]; // Show newest first
                          return _MovimientoItem(movimiento: m);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BalanceHeader extends StatelessWidget {
  final MovimientosViewModel vm;

  const _BalanceHeader({required this.vm});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppTheme.primaryColor.withValues(alpha: 0.05),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Ingresos',
                value: currencyFormat.format(vm.totalIngresos),
                color: Colors.green.shade600,
                icon: Icons.arrow_upward,
              ),
              _StatItem(
                label: 'Egresos',
                value: currencyFormat.format(vm.totalEgresos),
                color: AppTheme.errorColor,
                icon: Icons.arrow_downward,
              ),
            ],
          ),
          const Divider(height: 32),
          Text(
            'Balance Actual',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            currencyFormat.format(vm.balance),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: vm.balance >= 0 ? AppTheme.primaryColor : AppTheme.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _MovimientoItem extends StatelessWidget {
  final Movimiento movimiento;

  const _MovimientoItem({required this.movimiento});

  @override
  Widget build(BuildContext context) {
    final isIngreso = movimiento.tipo == MovimientoType.ingreso;
    final isEgreso = movimiento.tipo == MovimientoType.egreso;
    
    final color = isIngreso 
        ? Colors.green.shade600 
        : isEgreso 
            ? AppTheme.errorColor 
            : AppTheme.primaryColor;
            
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(
            isIngreso 
                ? Icons.arrow_upward 
                : isEgreso 
                    ? Icons.arrow_downward 
                    : Icons.info_outline,
            color: color,
          ),
        ),
        title: Text(movimiento.concepto),
        subtitle: Text(
          '${DateFormat('dd/MM/yyyy').format(movimiento.fecha)}${movimiento.categoria != null ? ' • ${movimiento.categoria}' : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (movimiento.tipo != MovimientoType.actividad)
              Text(
                '${isIngreso ? '+' : '-'}${currencyFormat.format(movimiento.monto)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovimientoFormPage(
                        movimiento: movimiento,
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  _confirmDelete(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, size: 20),
                    title: Text('Editar'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: AppTheme.errorColor, size: 20),
                    title: Text('Eliminar', style: TextStyle(color: AppTheme.errorColor)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Movimiento'),
        content: const Text('¿Estás seguro de que deseas eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<MovimientosViewModel>().eliminar(movimiento.id);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}

class _EmptyMovimientos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Sin movimientos aún',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
