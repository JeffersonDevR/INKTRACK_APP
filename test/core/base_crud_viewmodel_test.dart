import 'package:flutter_test/flutter_test.dart';
import 'package:InkTrack/core/base_crud_viewmodel.dart';

/// A minimal HasId subclass for testing the type constraint.
class _HasIdSubclass implements HasId {
  @override
  final String id;

  const _HasIdSubclass(this.id);
}

/// A concrete ViewModel that uses a valid HasId type.
class _TestViewModel extends BaseCrudViewModel<_HasIdSubclass> {}

void main() {
  group('BaseCrudViewModel T extends HasId constraint', () {
    test(
      'BUG-004: Valid HasId subclass compiles and works with _getId',
      () {
        final vm = _TestViewModel();
        final item = _HasIdSubclass('test-id-42');

        vm.add(item);

        expect(vm.items, hasLength(1));
        expect(vm.getById('test-id-42'), equals(item));
      },
    );

    test(
      'BUG-004: _getId returns correct id for items',
      () {
        final vm = _TestViewModel();
        vm.add(_HasIdSubclass('a'));
        vm.add(_HasIdSubclass('b'));

        expect(vm.getById('a')?.id, equals('a'));
        expect(vm.getById('b')?.id, equals('b'));
        expect(vm.getById('nonexistent'), isNull);
      },
    );

    test(
      'BUG-004: update and delete use _getId correctly',
      () {
        final vm = _TestViewModel();
        vm.add(_HasIdSubclass('x'));
        vm.add(_HasIdSubclass('y'));

        vm.update('x', _HasIdSubclass('x-updated'));
        expect(vm.getById('x-updated')?.id, equals('x-updated'));
        expect(vm.getById('x'), isNull);

        vm.delete('y');
        expect(vm.items, hasLength(1));
      },
    );
  });
}
