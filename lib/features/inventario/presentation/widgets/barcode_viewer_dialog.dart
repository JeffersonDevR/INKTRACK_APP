import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

class BarcodeViewerDialog extends StatelessWidget {
  final String code;
  final String productName;
  final bool isCustom;

  const BarcodeViewerDialog({
    super.key,
    required this.code,
    required this.productName,
    this.isCustom = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Código del Producto',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        productName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: BarcodeWidget(
                barcode: code.length <= 13 && _isNumeric(code) 
                    ? Barcode.ean13() 
                    : Barcode.qrCode(),
                data: code,
                width: 200,
                height: 200,
                drawText: true,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Escanea este código para identificar el producto',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (isCustom)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Código Personalizado',
                  style: TextStyle(
                    color: AppTheme.secondaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement share functionality if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad de compartir no implementada')),
                  );
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Compartir'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
