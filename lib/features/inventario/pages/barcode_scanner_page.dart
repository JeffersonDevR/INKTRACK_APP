import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'producto_form_page.dart';
import '../../movimientos/pages/movimiento_form_page.dart';
import '../../movimientos/models/movimiento.dart' as mov_model;
import '../viewmodels/inventario_viewmodel.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;
    _hasScanned = true;

    final viewModel = context.read<InventarioViewModel>();
    final productoExistente = viewModel.findProductoByCodigo(code);

    Navigator.of(context).pop(); // Close scanner
    
    if (productoExistente != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MovimientoFormPage(
            initialType: mov_model.MovimientoType.egreso,
            movimiento: mov_model.Movimiento(
              id: '', // New movement
              monto: 0,
              fecha: DateTime.now(),
              tipo: mov_model.MovimientoType.egreso,
              concepto: 'Restock: ${productoExistente.nombre}',
              productoId: productoExistente.id,
              categoria: productoExistente.categoria,
            ),
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductoFormPage(initialCodigoBarras: code),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear código'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                  default:
                    return const Icon(Icons.flash_auto);
                }
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Text(
              'Apunta al código de barras o QR del producto',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                shadows: [
                  Shadow(color: Colors.black87, blurRadius: 8),
                  Shadow(color: Colors.black54, blurRadius: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
