import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/models/movimiento.dart';
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/features/categorias/data/repositories/categorias_repository.dart';

@GenerateMocks([MovimientosRepository])
import 'movimientos_viewmodel_test.mocks.dart';

class _FakeCategoriasRepository implements CategoriasRepository {
  final List<CategoriaData> _items = [];

  @override
  Future<List<CategoriaData>> getAll(String tipo) async =>
      _items.where((c) => c.tipo == tipo).toList();

  @override
  Future<void> save(String nombre, String tipo) async {
    _items.add(CategoriaData(
      id: IdUtils.generateId(),
      nombre: nombre,
      tipo: tipo,
      syncStatus: 'synced',
    ));
  }

  @override
  Future<void> update(String id, String nuevoNombre) async {
    final index = _items.indexWhere((c) => c.id == id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(nombre: nuevoNombre);
    }
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((c) => c.id == id);
  }

  @override
  Future<bool> exists(String nombre, String tipo) async {
    return _items.any((c) => c.nombre == nombre && c.tipo == tipo);
  }
}

void main() {
  late MovimientosViewModel viewModel;
  late MockMovimientosRepository mockRepository;

  setUp(() {
    mockRepository = MockMovimientosRepository();
    when(mockRepository.getAll()).thenAnswer((_) async => []);
    viewModel = MovimientosViewModel(mockRepository, _FakeCategoriasRepository());
  });

  group('Duplicate Prevention', () {
    test(
        '2.1 [RED] should reject duplicate ID when adding a movement',
        () {
      final mov = Movimiento(
        id: 'dup-1',
        concepto: 'Duplicate',
        monto: 100,
        fecha: DateTime.now(),
        tipo: MovimientoType.ingreso,
      );
      viewModel.add(mov);
      viewModel.add(mov); // Same ID — should be rejected

      expect(viewModel.items.length, 1);
      expect(viewModel.items.first.id, 'dup-1');
    });

    test('2.2 [RED] should load movements when viewModel is created', () async {
      final mov = Movimiento(
        id: '1',
        concepto: 'Loaded',
        monto: 50,
        fecha: DateTime.now(),
        tipo: MovimientoType.egreso,
      );
      when(mockRepository.getAll()).thenAnswer((_) async => [mov]);
      viewModel = MovimientosViewModel(mockRepository, _FakeCategoriasRepository());

      // After a microtask, the async _init should have completed
      await Future.delayed(Duration.zero);

      expect(viewModel.items.length, 1);
      expect(viewModel.items.first.concepto, 'Loaded');
    });
  });

  group('MovimientosViewModel Date Filtering', () {
    test('should filter movements by date range', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final tomorrow = now.add(const Duration(days: 1));

      final mov1 = Movimiento(
        id: '1',
        concepto: 'Yesterday',
        monto: 100,
        fecha: yesterday,
        tipo: MovimientoType.ingreso,
      );
      final mov2 = Movimiento(
        id: '2',
        concepto: 'Today',
        monto: 200,
        fecha: now,
        tipo: MovimientoType.ingreso,
      );
      final mov3 = Movimiento(
        id: '3',
        concepto: 'Tomorrow',
        monto: 300,
        fecha: tomorrow,
        tipo: MovimientoType.egreso,
      );

      when(mockRepository.getAll()).thenAnswer((_) async => [mov1, mov2, mov3]);
      viewModel = MovimientosViewModel(mockRepository, _FakeCategoriasRepository());

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));

      // Set filter for "today only"
      final startOfToday = DateTime(now.year, now.month, now.day);
      final endOfToday = startOfToday
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1));

      viewModel.setDateFilter(startOfToday, endOfToday);

      expect(viewModel.filteredItems.length, 1);
      expect(viewModel.filteredItems.first.concepto, 'Today');
      expect(viewModel.totalIngresosFiltered, 200.0);
      expect(viewModel.totalEgresosFiltered, 0.0);
    });

    test('should return all items if filter is null', () {
      final now = DateTime.now();
      viewModel.add(
        Movimiento(
          id: '1',
          concepto: 'A',
          monto: 10,
          fecha: now,
          tipo: MovimientoType.ingreso,
        ),
      );

      viewModel.clearDateFilter();

      expect(viewModel.filteredItems.length, 1);
      expect(viewModel.totalIngresosFiltered, 10.0);
    });
  });
}
