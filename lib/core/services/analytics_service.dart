import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:InkTrack/core/services/log_service.dart';

class AnalyticsEvent {
  final String name;
  final Map<String, dynamic>? properties;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.name,
    this.properties,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'name': name,
    'properties': properties,
    'timestamp': timestamp.toIso8601String(),
  };
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._();
  static AnalyticsService get instance => _instance;
  AnalyticsService._();

  final List<AnalyticsEvent> _events = [];
  bool _globalHandlerSet = false;

  void init() {
    if (_globalHandlerSet) return;
    _globalHandlerSet = true;

    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      track('flutter_error', properties: {
        'exception': details.exceptionAsString(),
        'stack': details.stack.toString(),
        'library': details.context?.name,
      });
      original?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      track('platform_error', properties: {
        'error': error.toString(),
        'stack': stack.toString(),
      });
      return true;
    };

    track('analytics_init');
  }

  void track(String name, {Map<String, dynamic>? properties}) {
    final event = AnalyticsEvent(name: name, properties: properties);
    _events.add(event);
    LogService.instance.debug('Analytics', '$name ${properties != null ? jsonEncode(properties) : ''}');
  }

  Future<String> export() async {
    final buffer = StringBuffer();
    for (final event in _events) {
      buffer.writeln(jsonEncode(event.toJson()));
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/analytics_export_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(buffer.toString());
    return file.path;
  }
}
