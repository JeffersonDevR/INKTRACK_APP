import 'package:flutter/material.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

enum FabTab { home, clientes, proveedores, inventario, reportes }

class SpeedDialFab extends StatefulWidget {
  final VoidCallback? onVentaPressed;
  final VoidCallback? onIngresoPressed;
  final VoidCallback? onEgresoPressed;
  final VoidCallback? onRestockPressed;
  final VoidCallback? onClientePressed;
  final VoidCallback? onProveedorPressed;
  final VoidCallback? onProductoPressed;
  final VoidCallback? onReportesPressed;
  final VoidCallback? onExportPdfPressed;
  final VoidCallback? onExportExcelPressed;
  final VoidCallback? onScanBarcodePressed;
  final VoidCallback? onOcrScanPressed;
  final FabTab currentTab;

  const SpeedDialFab({
    super.key,
    this.onVentaPressed,
    this.onIngresoPressed,
    this.onEgresoPressed,
    this.onRestockPressed,
    this.onClientePressed,
    this.onProveedorPressed,
    this.onProductoPressed,
    this.onReportesPressed,
    this.onExportPdfPressed,
    this.onExportExcelPressed,
    this.onScanBarcodePressed,
    this.onOcrScanPressed,
    this.currentTab = FabTab.home,
  });

  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isReportes = widget.currentTab == FabTab.reportes;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isReportes) ...[
          _buildSpeedDialOption(
            icon: Icons.table_chart,
            label: 'Excel',
            color: Colors.green,
            onTap: () {
              _toggle();
              widget.onExportExcelPressed?.call();
            },
            delay: 0,
          ),
          const SizedBox(height: 8),
          _buildSpeedDialOption(
            icon: Icons.picture_as_pdf,
            label: 'PDF',
            color: Colors.red,
            onTap: () {
              _toggle();
              widget.onExportPdfPressed?.call();
            },
            delay: 1,
          ),
          const SizedBox(height: 8),
          _buildSpeedDialOption(
            icon: Icons.bar_chart,
            label: 'Reportes',
            color: AppTheme.primaryColor,
            onTap: () {
              _toggle();
              widget.onReportesPressed?.call();
            },
            delay: 2,
          ),
          const SizedBox(height: 8),
          _buildSpeedDialOption(
            icon: Icons.arrow_upward,
            label: 'Egreso',
            color: AppTheme.errorColor,
            onTap: () {
              _toggle();
              widget.onEgresoPressed?.call();
            },
            delay: 3,
          ),
          const SizedBox(height: 8),
          _buildSpeedDialOption(
            icon: Icons.arrow_downward,
            label: 'Ingreso',
            color: AppTheme.secondaryColor,
            onTap: () {
              _toggle();
              widget.onIngresoPressed?.call();
            },
            delay: 4,
          ),
        ] else ...[
          if (widget.currentTab == FabTab.home) ...[
            _buildSpeedDialOption(
              icon: Icons.document_scanner,
              label: 'OCR',
              color: AppTheme.accentColor,
              onTap: () {
                _toggle();
                widget.onOcrScanPressed?.call();
              },
              delay: 0,
            ),
            const SizedBox(height: 8),
          ],
          _buildSpeedDialOption(
            icon: Icons.qr_code_scanner,
            label: 'Código',
            color: AppTheme.primaryColor,
            onTap: () {
              _toggle();
              widget.onScanBarcodePressed?.call();
            },
            delay: 1,
          ),
          const SizedBox(height: 8),
          _buildSpeedDialOption(
            icon: Icons.add_box,
            label: 'Producto',
            color: AppTheme.primaryColor,
            onTap: () {
              _toggle();
              widget.onProductoPressed?.call();
            },
            delay: 2,
          ),
          if (widget.currentTab == FabTab.clientes) ...[
            const SizedBox(height: 8),
            _buildSpeedDialOption(
              icon: Icons.person_add,
              label: 'Cliente',
              color: AppTheme.primaryColor,
              onTap: () {
                _toggle();
                widget.onClientePressed?.call();
              },
              delay: 2,
            ),
          ],
          if (widget.currentTab == FabTab.proveedores) ...[
            const SizedBox(height: 8),
            _buildSpeedDialOption(
              icon: Icons.local_shipping,
              label: 'Proveedor',
              color: AppTheme.primaryColor,
              onTap: () {
                _toggle();
                widget.onProveedorPressed?.call();
              },
              delay: 2,
            ),
          ],
          if (widget.currentTab == FabTab.inventario) ...[
            const SizedBox(height: 8),
            _buildSpeedDialOption(
              icon: Icons.inventory,
              label: 'Restock',
              color: AppTheme.secondaryColor,
              onTap: () {
                _toggle();
                widget.onRestockPressed?.call();
              },
              delay: 2,
            ),
          ],
          const SizedBox(height: 8),
          _buildSpeedDialOption(
            icon: Icons.bar_chart,
            label: 'Reportes',
            color: AppTheme.primaryColor,
            onTap: () {
              _toggle();
              widget.onReportesPressed?.call();
            },
            delay: 3,
          ),
          const SizedBox(height: 8),
          _buildSpeedDialOption(
            icon: Icons.arrow_upward,
            label: 'Egreso',
            color: AppTheme.errorColor,
            onTap: () {
              _toggle();
              widget.onEgresoPressed?.call();
            },
            delay: 4,
          ),
          const SizedBox(height: 8),
          _buildSpeedDialOption(
            icon: Icons.arrow_downward,
            label: 'Ingreso',
            color: AppTheme.secondaryColor,
            onTap: () {
              _toggle();
              widget.onIngresoPressed?.call();
            },
            delay: 5,
          ),
        ],
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: AppTheme.primaryColor,
          child: AnimatedIcon(
            icon: AnimatedIcons.add_event,
            progress: _controller,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedDialOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required int delay,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = _controller.value;
        final translateY = (1 - scale) * 50 * (delay + 1) * 0.15;
        final opacity = _controller.value;

        return Transform.scale(
          scale: scale,
          child: Transform.translate(
            offset: Offset(0, translateY),
            child: Opacity(opacity: opacity, child: child),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onTap,
              icon: Icon(icon, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
