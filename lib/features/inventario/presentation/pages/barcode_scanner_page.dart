import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:InkTrack/features/inventario/presentation/pages/producto_form_page.dart';
import 'package:InkTrack/features/proveedores/presentation/pages/crear_pedido_page.dart';
import 'package:InkTrack/features/inventario/data/models/producto.dart';
import 'package:InkTrack/features/inventario/presentation/viewmodels/inventario_viewmodel.dart';
import 'package:InkTrack/features/inventario/presentation/widgets/orphan_assign_dialog.dart';
import 'package:InkTrack/core/theme/app_theme.dart';
import 'package:InkTrack/core/utils/burst_scan_handler.dart';
import 'package:InkTrack/core/utils/gs1_barcode_parser.dart';

enum BarcodeScannerMode { restock, selectProduct, scanCode, burst }

typedef BurstScanCallback = void Function(Producto producto, {double? weightKg, double? embeddedPrice});

class BarcodeScannerPage extends StatefulWidget {
  final BarcodeScannerMode mode;
  final BurstScanCallback? onBurstScan;

  const BarcodeScannerPage({
    super.key,
    this.mode = BarcodeScannerMode.restock,
    this.onBurstScan,
  });

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  MobileScannerController? _controller;
  final BurstScanHandler _burstHandler = BurstScanHandler();
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: widget.mode == BarcodeScannerMode.burst
          ? DetectionSpeed.noDuplicates
          : DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    if (widget.mode == BarcodeScannerMode.burst) {
      _onDetectBurst(code);
    } else {
      _onDetectSingle(code);
    }
  }

  void _onDetectSingle(String code) {
    if (_hasScanned) return;
    _hasScanned = true;

    final viewModel = context.read<InventarioViewModel>();
    final productoExistente = viewModel.findProductoByCodigo(code);

    switch (widget.mode) {
      case BarcodeScannerMode.restock:
        if (productoExistente != null) {
          _mostrarDialogoRestock(code, productoExistente);
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductoFormPage(initialCodigoBarras: code),
            ),
          );
        }
      case BarcodeScannerMode.selectProduct:
        if (productoExistente != null) {
          Navigator.of(context).pop(productoExistente);
        } else {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.productoNoEncontrado),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      case BarcodeScannerMode.scanCode:
        Navigator.of(context).pop(code);
      case BarcodeScannerMode.burst:
        break;
    }
  }

  void _onDetectBurst(String code) {
    if (!_burstHandler.shouldProcess(code)) return;

    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.read<InventarioViewModel>();

    Gs1ParseResult? gs1Result;
    if (code.startsWith('31') || code.startsWith('32')) {
      try {
        gs1Result = Gs1BarcodeParser().parse(code);
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.gs1InvalidWeightCode),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }
    }

    final lookupCode = gs1Result?.productId ?? code;
    final productoExistente = viewModel.findProductoByCodigo(lookupCode);

    if (productoExistente != null) {
      HapticFeedback.mediumImpact();
      widget.onBurstScan?.call(
        productoExistente,
        weightKg: gs1Result?.weightKg,
        embeddedPrice: gs1Result?.price,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.productAddedCountSnackbar(productoExistente.nombre, 1),
          ),
          duration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      handleOrphanCode(
        context,
        codigo: code,
        onProductAssigned: (producto) {
          viewModel.updateProducto(producto);
        },
      );
    }
  }

  void _mostrarDialogoRestock(String codigo, Producto productoExistente) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.productoYaExiste),
        content: Text(
          l10n.productoYaExisteMensaje(codigo, productoExistente.nombre),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _hasScanned = false;
            },
            child: Text(l10n.cancelar),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CrearPedidoPage(
                    initialProducto: productoExistente,
                  ),
                ),
              );
            },
            child: Text(l10n.crearPedido),
          ),
        ],
      ),
    );
  }

  @visibleForTesting
  void onDetectForTest(BarcodeCapture capture) => _onDetect(capture);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == BarcodeScannerMode.burst
            ? l10n.burstModeLabel
            : l10n.escanearCodigoTitulo),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller!,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                );
              },
            ),
            onPressed: () => _controller?.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller!, onDetect: _onDetect),
          CustomPaint(
            painter: ScannerOverlayPainter(),
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final scanAreaSize = size.width * 0.7;
    final scanAreaLeft = (size.width - scanAreaSize) / 2;
    final scanAreaTop = (size.height - scanAreaSize) / 2;

    final scanRect = Rect.fromLTWH(
      scanAreaLeft,
      scanAreaTop,
      scanAreaSize,
      scanAreaSize,
    );

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, const Radius.circular(12)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
