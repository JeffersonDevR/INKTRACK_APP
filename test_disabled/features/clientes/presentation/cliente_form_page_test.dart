import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/features/clientes/data/models/cliente.dart';
import 'package:InkTrack/features/clientes/presentation/pages/cliente_form_page.dart';
import 'package:InkTrack/features/clientes/presentation/viewmodels/clientes_viewmodel.dart';
import 'package:InkTrack/features/clientes/data/repositories/clientes_repository.dart';
import 'package:InkTrack/features/clientes/domain/use_cases/registrar_pago_cliente_use_case.dart';
import 'package:InkTrack/features/movimientos/presentation/viewmodels/movimientos_viewmodel.dart';
import 'package:InkTrack/features/movimientos/data/repositories/movimientos_repository.dart';
import 'package:InkTrack/features/movimientos/domain/use_cases/crear_movimiento_use_case.dart';
import 'package:InkTrack/features/categorias/data/repositories/categorias_repository.dart';
import 'package:InkTrack/core/utils/id_utils.dart';
import 'package:InkTrack/core/data/local/database.dart';

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
  late ClientesViewModel clientesViewModel;
  late MovimientosViewModel movimientosViewModel;

  setUp(() {
    final clientesRepo = InMemoryClientesRepository();
    final movimientosRepo = InMemoryMovimientosRepository();
    final crearMov = CrearMovimientoUseCase(movimientosRepo);
    clientesViewModel = ClientesViewModel(
      clientesRepo,
      RegistrarPagoClienteUseCase(clientesRepo, crearMov),
      crearMov,
    );
    movimientosViewModel = MovimientosViewModel(
      movimientosRepo,
      _FakeCategoriasRepository(),
    );
  });

  Widget createTestWidget({Cliente? cliente}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: clientesViewModel),
        ChangeNotifierProvider.value(value: movimientosViewModel),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        supportedLocales: const [Locale('es')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: ClienteFormPage(cliente: cliente),
      ),
    );
  }

  group('ClienteFormPage Widget Tests', () {
    testWidgets('TC-W01: renders form fields for new cliente', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Nuevo Cliente'), findsOneWidget);
      expect(find.text('Nombre'), findsOneWidget);
      expect(find.text('Teléfono'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Guardar'), findsOneWidget);
    });

    testWidgets('TC-W02: renders form fields for editing cliente', (
      tester,
    ) async {
      final existingCliente = Cliente(
        id: 'test-1',
        nombre: 'Juan Test',
        telefono: '3001112222',
        email: 'juan@test.com',
      );

      await tester.pumpWidget(createTestWidget(cliente: existingCliente));

      expect(find.text('Editar Cliente'), findsOneWidget);
      expect(find.text('Actualizar'), findsOneWidget);
      expect(find.text('Juan Test'), findsOneWidget);
      expect(find.text('3001112222'), findsOneWidget);
      expect(find.text('juan@test.com'), findsOneWidget);
    });

    testWidgets('TC-W03: shows validation error for empty nombre', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Por favor ingrese el nombre'), findsOneWidget);
    });

    testWidgets('TC-W04: shows validation error for short nombre', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.widgetWithText(TextFormField, 'Nombre'), 'A');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Mínimo 2 caracteres'), findsOneWidget);
    });

    testWidgets('TC-W05: shows validation error for invalid phone length', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Teléfono'),
        '123',
      );
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(
        find.text('El teléfono debe tener exactamente 10 dígitos'),
        findsOneWidget,
      );
    });

    testWidgets('TC-W06: shows validation error for invalid email', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'invalid-email',
      );
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Por favor ingrese un email válido'), findsOneWidget);
    });

    testWidgets('TC-W07: phone field only accepts digits', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Teléfono'),
        '300abc1234',
      );
      await tester.pumpAndSettle();

      expect(find.text('300abc1234'), findsNothing);
      expect(find.text('3001234'), findsOneWidget);
    });

    testWidgets('TC-W08: nombre field has 30 character limit', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textField = find.widgetWithText(TextFormField, 'Nombre');
      await tester.enterText(
        textField,
        'EsteNombreEsMuyLargoYExcedeLos30CaracteresPermitidos',
      );
      await tester.pumpAndSettle();

      final textFormField = tester.widget<TextFormField>(textField);
      expect(textFormField.controller?.text.length, lessThanOrEqualTo(30));
    });
  });
}
