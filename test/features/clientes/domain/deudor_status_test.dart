import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/domain/deudor_status.dart';

void main() {
  group('computeStatus tests', () {
    final baseClient = Cliente(
      id: 'cli-1',
      nombre: 'Carlos',
      telefono: '12345678',
      saldoPendiente: 500.0,
      esFiado: true,
    );

    final now = DateTime(2025, 6, 10);

    test('saldo == 0 -> alDia', () {
      final client = baseClient.copyWith(saldoPendiente: 0.0);
      expect(computeStatus(client, now: now), equals(DeudorStatus.alDia));
    });

    test('saldo > 0, promise date is past -> vencido', () {
      final client = baseClient.copyWith(promesaPago: DateTime(2025, 6, 9));
      expect(computeStatus(client, now: now), equals(DeudorStatus.vencido));
    });

    test('saldo > 0, promise date is today -> porVencer', () {
      final client = baseClient.copyWith(promesaPago: DateTime(2025, 6, 10));
      expect(computeStatus(client, now: now), equals(DeudorStatus.porVencer));
    });

    test('saldo > 0, promise date is in 5 days -> porVencer', () {
      final client = baseClient.copyWith(promesaPago: DateTime(2025, 6, 15));
      expect(computeStatus(client, now: now), equals(DeudorStatus.porVencer));
    });

    test('saldo > 0, promise date is in 7 days -> porVencer', () {
      final client = baseClient.copyWith(promesaPago: DateTime(2025, 6, 17));
      expect(computeStatus(client, now: now), equals(DeudorStatus.porVencer));
    });

    test('saldo > 0, promise date is in 8 days -> alDia', () {
      final client = baseClient.copyWith(promesaPago: DateTime(2025, 6, 18));
      expect(computeStatus(client, now: now), equals(DeudorStatus.alDia));
    });

    test('saldo > 0, no promise date set -> alDia', () {
      final client = baseClient.copyWith(promesaPago: null);
      expect(computeStatus(client, now: now), equals(DeudorStatus.alDia));
    });
  });
}
