import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';

void main() {
  group('Credit limit validation math tests', () {
    test('blocked: cliente pending balance + new credit sale exceeds limit', () {
      final client = Cliente(
        id: 'cli-1',
        nombre: 'Carlos',
        telefono: '12345678',
        saldoPendiente: 800.0,
        limiteCredito: 1000.0,
      );

      final newVentaMonto = 300.0;
      final isBlocked = (client.saldoPendiente + newVentaMonto) > (client.limiteCredito ?? double.infinity);
      
      expect(isBlocked, isTrue);
    });

    test('allowed: cliente pending balance + new credit sale is under limit', () {
      final client = Cliente(
        id: 'cli-1',
        nombre: 'Carlos',
        telefono: '12345678',
        saldoPendiente: 500.0,
        limiteCredito: 1000.0,
      );

      final newVentaMonto = 300.0;
      final isBlocked = (client.saldoPendiente + newVentaMonto) > (client.limiteCredito ?? double.infinity);
      
      expect(isBlocked, isFalse);
    });
  });
}
