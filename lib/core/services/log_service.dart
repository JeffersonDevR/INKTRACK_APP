import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

enum LogLevel { debug, info, warning, error }

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
  });

  String toLine() {
    final t = timestamp.toIso8601String();
    return '[$t][${level.name.toUpperCase()}][$tag] $message';
  }
}

class LogService {
  static final LogService _instance = LogService._();
  static LogService get instance => _instance;
  LogService._();

  final List<LogEntry> _entries = [];
  File? _logFile;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _logFile = File('${dir.path}/inktrack_log.txt');
    final now = DateTime.now();
    await _logFile!.writeAsString(
      '=== InkTrack Log — ${now.toLocal()} ===\n',
    );
    info('LogService', 'Log initialized at ${_logFile!.path}');
  }

  void _log(LogLevel level, String tag, String message) {
    final entry = LogEntry(timestamp: DateTime.now(), level: level, tag: tag, message: message);
    _entries.add(entry);
    debugPrint(entry.toLine());
    _logFile?.writeAsStringSync('${entry.toLine()}\n', mode: FileMode.append);
  }

  void debug(String tag, String message) => _log(LogLevel.debug, tag, message);
  void info(String tag, String message) => _log(LogLevel.info, tag, message);
  void warning(String tag, String message) => _log(LogLevel.warning, tag, message);
  void error(String tag, String message) => _log(LogLevel.error, tag, message);

  Future<String> export() async {
    final buffer = StringBuffer();
    for (final entry in _entries) {
      buffer.writeln(entry.toLine());
    }
    final dir = await getApplicationDocumentsDirectory();
    final exportFile = File('${dir.path}/inktrack_log_export_${DateTime.now().millisecondsSinceEpoch}.txt');
    await exportFile.writeAsString(buffer.toString());
    return exportFile.path;
  }

  Future<File?> get logFile async => _logFile;
}
