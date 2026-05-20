import 'package:flutter/material.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

enum FabTab { home, clientes, proveedores, inventario }

class SpeedDialFab extends StatefulWidget {
  final VoidCallback? onVentaPressed;
  final VoidCallback? onIngresoPressed;
  final VoidCallback? onEgresoPressed;
  final VoidCallback? onRestockPressed;
  final VoidCallback? onClientePressed;
  final VoidCallback? onProveedorPressed;
  final VoidCallback? onPedidoPressed;
  final VoidCallback? onProductoPressed;
  final VoidCallback? onScanBarcodePressed;
  final FabTab currentTab;

  const SpeedDialFab({
    super.key,
    this.onVentaPressed,
    this.onIngresoPressed,
    this.onEgresoPressed,
    this.onRestockPressed,
    this.onClientePressed,
    this.onProveedorPressed,
    this.onPedidoPressed,
    this.onProductoPressed,
    this.onScanBarcodePressed,
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
    final l10n = AppLocalizations.of(context)!;
    final List<Widget> options = [];

    switch (widget.currentTab) {
      case FabTab.clientes:
        options.add(
          _buildOption(
            icon: Icons.person_add_rounded,
            label: l10n.nuevoCliente,
            color: AppTheme.primaryColor,
            onTap: widget.onClientePressed,
            delay: 0,
          ),
        );
        break;
      case FabTab.proveedores:
        options.add(
          _buildOption(
            icon: Icons.local_shipping_rounded,
            label: l10n.nuevoProveedor,
            color: AppTheme.primaryColor,
            onTap: widget.onProveedorPressed,
            delay: 0,
          ),
        );
        options.add(const SizedBox(height: 12));
        options.add(
          _buildOption(
            icon: Icons.shopping_cart_rounded,
            label: l10n.nuevoPedido,
            color: AppTheme.secondaryColor,
            onTap: widget.onPedidoPressed,
            delay: 1,
          ),
        );
        break;
      case FabTab.inventario:
        options.add(
          _buildOption(
            icon: Icons.add_box_rounded,
            label: l10n.nuevoProducto,
            color: AppTheme.primaryColor,
            onTap: widget.onProductoPressed,
            delay: 0,
          ),
        );
        break;
      case FabTab.home:
      default:
        // FAB is usually hidden in Home, but if it were shown, we could add options here
        break;
    }

    if (options.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...options.reversed,
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: AppTheme.primaryColor,
          elevation: 4,
          child: AnimatedIcon(
            icon: AnimatedIcons.add_event,
            progress: _controller,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
    required int delay,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = _controller.value;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: _controller.value,
            child: child,
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkCard
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FloatingActionButton.small(
            heroTag: label,
            onPressed: () {
              _toggle();
              onTap?.call();
            },
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
