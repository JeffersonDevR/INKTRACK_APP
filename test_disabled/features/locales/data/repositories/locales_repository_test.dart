import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/data/base_repository.dart';
import 'package:InkTrack/features/locales/data/models/local.dart';
import 'package:InkTrack/features/locales/data/repositories/locales_repository.dart';

/// Minimal concrete implementation to verify LocalesRepository contract.
class TestLocalesRepository implements LocalesRepository {
  final List<Local> _items = [];

  @override
  Future<List<Local>> getAll() async => List.unmodifiable(_items);

  @override
  Future<Local?> getById(String id) async {
    try {
      return _items.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(Local local) async {
    _items.add(local);
  }

  @override
  Future<void> update(String id, Local local) async {
    final index = _items.indexWhere((l) => l.id == id);
    if (index != -1) _items[index] = local;
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((l) => l.id == id);
  }
}

void main() {
  late TestLocalesRepository repository;

  setUp(() {
    repository = TestLocalesRepository();
  });

  group('LocalesRepository — BaseRepository contract', () {
    test('implements BaseRepository<Local>', () {
      // Structural check: does it have all BaseRepository methods?
      expect(repository, isA<BaseRepository<Local>>(),
          reason: 'LocalesRepository must implement BaseRepository<Local>');
    });

    test('getAll returns all saved locales', () async {
      final local = Local(id: 'loc-1', nombre: 'Tienda Centro');
      await repository.save(local);

      final items = await repository.getAll();
      expect(items.length, 1);
      expect(items.first.nombre, 'Tienda Centro');
    });

    test('getById returns specific locale', () async {
      final local = Local(id: 'loc-2', nombre: 'Tienda Norte');
      await repository.save(local);

      final result = await repository.getById('loc-2');
      expect(result, isNotNull);
      expect(result!.nombre, 'Tienda Norte');
    });

    test('getById returns null for unknown id', () async {
      final result = await repository.getById('nonexistent');
      expect(result, isNull);
    });

    test('update modifies existing locale', () async {
      await repository.save(Local(id: 'loc-3', nombre: 'Original'));
      final updated = Local(id: 'loc-3', nombre: 'Modificado');
      await repository.update('loc-3', updated);

      final result = await repository.getById('loc-3');
      expect(result, isNotNull);
      expect(result!.nombre, 'Modificado');
    });

    test('delete removes locale', () async {
      await repository.save(Local(id: 'loc-4', nombre: 'A Eliminar'));
      await repository.delete('loc-4');

      final result = await repository.getById('loc-4');
      expect(result, isNull);
    });
  });
}
