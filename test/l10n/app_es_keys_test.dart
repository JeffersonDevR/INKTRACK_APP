import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('app_es.arb keys for product-form and scanner restock dialogs', () {
    late Map<String, dynamic> arb;

    setUpAll(() {
      final file = File('${Directory.current.path}/lib/l10n/app_es.arb');
      arb = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    });

    test('contains scanner restock dialog keys', () {
      expect(arb['productoYaExiste'], 'Producto ya existe');
      expect(arb['crearMovimiento'], 'Crear movimiento');
      expect(arb['productoYaExisteMensaje'], isA<String>());
      expect(
        (arb['productoYaExisteMensaje'] as String).contains('{codigo}'),
        isTrue,
      );
      expect(
        (arb['productoYaExisteMensaje'] as String).contains('{nombre}'),
        isTrue,
      );
    });

    test('contains product-form Ganancias keys', () {
      expect(arb['margenGanancia'], 'Margen de Ganancia');
      expect(arb['porcentajeGanancia'], 'Porcentaje de Ganancia');
      expect(arb['gananciaNeta'], 'Ganancia Neta');
      expect(arb['costo'], 'Costo');
    });

    test('contains GS1 parser error keys', () {
      expect(arb['gs1InvalidWeightCode'], 'Código de peso/precio no válido');
      expect(arb['gs1ParseError'], 'No se pudo interpretar el código de peso variable');
    });

    test('contains scanner modo-ráfaga and orphan dialog keys', () {
      expect(arb['orphanCodeTitle'], 'Código no registrado');
      expect(arb['orphanAssignExistingAction'], 'Asignar a producto existente');
      expect(arb['orphanCreateNewAction'], 'Crear nuevo producto');
      expect(arb['actionCancel'], 'Cancelar');
      expect(arb['burstModeLabel'], 'Modo ráfaga');
      expect(arb['productAddedCountSnackbar'], isA<String>());
      expect(
        (arb['productAddedCountSnackbar'] as String).contains('{producto}'),
        isTrue,
      );
      expect(
        (arb['productAddedCountSnackbar'] as String).contains('{n}'),
        isTrue,
      );
    });

    test('contains database migration error keys', () {
      expect(arb['databaseMigrationErrorTitle'], 'Error de base de datos');
      expect(arb['databaseMigrationErrorMessage'], isA<String>());
    });

    test('contains credit limit and abonos keys', () {
      expect(arb['creditLimitExceededTitle'], 'Límite de crédito excedido');
      expect(arb['creditLimitExceededMessage'], isA<String>());
      expect(arb['creditLimitContinueAnyway'], '¿Desea continuar de todos modos?');
      expect(arb['abonoHistoryTitle'], 'Historial de Abonos');
      expect(arb['registerAbonoTitle'], 'Registrar Abono');
      expect(arb['abonoAmountLabel'], 'Monto del Abono');
      expect(arb['remainingBalanceLabel'], 'Saldo Restante');
      expect(arb['saveAbonoAction'], 'Registrar Pago');
    });

    test('contains debtor status traffic light keys', () {
      expect(arb['debtorStatusUpToDate'], 'Al día');
      expect(arb['debtorStatusDueSoon'], 'Por vencer');
      expect(arb['debtorStatusOverdue'], 'Vencido');
      expect(arb['paymentPromiseDateLabel'], 'Promesa de pago');
    });

    test('contains pedidos-recepcion l10n keys (Chain 5)', () {
      expect(arb['orderReceptionTitle'], 'Recepción de Pedido');
      expect(arb['scanReceivedProductsHint'], 'Escanea los productos recibidos');
      expect(arb['requestedCountLabel'], 'Solicitado');
      expect(arb['receivedCountLabel'], 'Recibido');
      expect(arb['discrepancyLabel'], 'Discrepancia');
      expect(arb['discrepancySummaryMessage'], isA<String>());
      expect(
        (arb['discrepancySummaryMessage'] as String).contains('{received}'),
        isTrue,
      );
      expect(
        (arb['discrepancySummaryMessage'] as String).contains('{requested}'),
        isTrue,
      );
      expect(arb['receptionCompleteMessage'], 'Recepción completada');
      expect(arb['receptionPartialMessage'], 'Recepción parcial');
      expect(arb['reorderSuggestionTitle'], 'Sugerencia de Pedido');
      expect(arb['productsBelowMinimumMessage'], 'Productos por debajo del mínimo');
      expect(arb['reorderProductLineLabel'], isA<String>());
      expect(
        (arb['reorderProductLineLabel'] as String).contains('{producto}'),
        isTrue,
      );
      expect(
        (arb['reorderProductLineLabel'] as String).contains('{actual}'),
        isTrue,
      );
      expect(
        (arb['reorderProductLineLabel'] as String).contains('{minimo}'),
        isTrue,
      );
      expect(arb['createSuggestedOrderAction'], 'Crear Pedido Sugerido');
      expect(arb['confirmPartialReceptionAction'], 'Confirmar Recepción Parcial');
      expect(arb['markDeliveredAction'], 'Marcar como Entregado');
    });

    test('contains reportes-avanzados l10n keys (Chain 6)', () {
      expect(arb['reportFiltersTitle'], 'Filtros de Reporte');
      expect(arb['filterOnlyDebtors'], 'Solo deudores');
      expect(arb['filterAbonosOfMonth'], 'Abonos del mes');
      expect(arb['filterTopSold'], 'Más vendidos');
      expect(arb['filterCriticalInventoryValorized'], 'Inventario crítico valorizado');
      expect(arb['filterTopN'], isA<String>());
      expect((arb['filterTopN'] as String).contains('{n}'), isTrue);
      expect(arb['filterIncludeCost'], 'Incluir costo');
      expect(arb['filterDateRange'], 'Rango de fechas');
      expect(arb['filterCustomer'], 'Cliente');
      expect(arb['filterProduct'], 'Producto');
      expect(arb['movementsReportTitle'], 'Reporte de Movimientos');
      expect(arb['inventoryReportTitle'], 'Reporte de Inventario');
      expect(arb['debtorsReportTitle'], 'Reporte de Deudores');
      expect(arb['criticalInventoryValorizedTitle'], 'Inventario Crítico Valorizado');
      expect(arb['pdfPreviewAction'], 'Vista Previa PDF');
      expect(arb['shareAction'], 'Compartir');
      expect(arb['closeAction'], 'Cerrar');
    });
  });
}


