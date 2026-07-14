import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/ventas/data/models/venta.dart';
import 'package:InkTrack/features/ventas/data/repositories/drift_ventas_repository.dart';

void main() {
  late AppDatabase db;
  late DriftVentasRepository repository;

  setUp(() {
    db = AppDatabase.fromConnection(NativeDatabase.memory());
    repository = DriftVentasRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Venta esFiado tests', () {
    test('credit sale persists esFiado column and is queryable', () async {
      // 1. Save credit sale (esFiado = true)
      final venta = Venta(
        id: 'v-1',
        monto: 300.0,
        fecha: DateTime(2025, 6, 1),
        esFiado: true,
        clienteId: 'cli-1',
      );

      await repository.save(venta);

      // 2. Retrieve and assert
      final retrieved = await repository.getById('v-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.esFiado, isTrue);

      // 3. Query total credit sales for cli-1
      final query = await db.customSelect(
        "SELECT SUM(monto) AS total_fiado FROM ventas WHERE cliente_id = 'cli-1' AND es_fiado = 1"
      ).getSingle();

      expect(query.read<double>('total_fiado'), equals(300.0));
    });
  });
}
