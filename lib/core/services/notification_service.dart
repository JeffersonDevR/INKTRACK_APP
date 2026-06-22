import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:InkTrack/features/proveedores/data/models/pedido_proveedor.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelId = 'pedidos_alerts';
  static const String _channelName = 'Alertas de Pedidos';
  static const String _channelDesc =
      'Notificaciones sobre entregas de pedidos próximas';

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to pedidos page
  }

  List<PedidoProveedor> getPedidosProximos(List<PedidoProveedor> todos) {
    final now = DateTime.now();
    return todos.where((p) {
      if (p.isEntregado) return false;
      final entrega = DateTime(
        p.fechaEntrega.year,
        p.fechaEntrega.month,
        p.fechaEntrega.day,
      );
      final today = DateTime(now.year, now.month, now.day);
      final diff = entrega.difference(today).inDays;
      return diff >= -1 && diff <= 1;
    }).toList()..sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));
  }

  Future<void> checkAndNotify(List<PedidoProveedor> pedidos) async {
    if (!_initialized) await initialize();

    final pedidosProximos = getPedidosProximos(pedidos);
    if (pedidosProximos.isEmpty) return;

    final dateFormat = DateFormat('dd/MM', 'es_CO');
    final body = pedidosProximos
        .map((p) {
          final fecha = dateFormat.format(p.fechaEntrega);
          final nombre = p.proveedorNombre ?? 'Proveedor';
          return '$nombre - $fecha';
        })
        .join('\n');

    await _showNotification(
      id: 1,
      title:
          '${pedidosProximos.length} entrega${pedidosProximos.length == 1 ? '' : 's'} pendiente${pedidosProximos.length == 1 ? '' : 's'}',
      body: body,
    );
  }

  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
