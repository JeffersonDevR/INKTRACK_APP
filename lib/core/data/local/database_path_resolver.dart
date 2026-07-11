import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Resolves the SQLite database file path used by the app.
///
/// The default location is the platform's application documents directory,
/// which keeps backward compatibility with existing installations. For
/// development/debugging (e.g. inspecting the database with DBeaver), the
/// directory can be overridden with the `INKTRACK_DB_PATH` environment
/// variable or a `--dart-define=INKTRACK_DB_PATH=...` compile-time define.
class DatabasePathResolver {
  static const String _defaultFileName = 'db.sqlite';
  static const String _envVarName = 'INKTRACK_DB_PATH';

  DatabasePathResolver._();

  /// Returns the [File] that should be used as the SQLite database.
  ///
  /// If [_envVarName] is set, it is interpreted as a directory. The directory
  /// is created if it does not exist. The database file is always named
  /// [_defaultFileName] inside that directory.
  static Future<File> resolve() async {
    final String? envPath = _readEnvPath();
    final Directory dbFolder;

    if (envPath != null && envPath.isNotEmpty) {
      dbFolder = Directory(envPath);
      if (!dbFolder.existsSync()) {
        dbFolder.createSync(recursive: true);
      }
    } else {
      dbFolder = await getApplicationDocumentsDirectory();
    }

    final file = File(p.join(dbFolder.path, _defaultFileName));
    debugPrint('[DatabasePathResolver] SQLite file: ${file.absolute.path}');
    return file;
  }

  /// Reads the override path from the process environment or compile-time
  /// dart-define. Web is ignored because [Platform] is unavailable there.
  static String? _readEnvPath() {
    if (kIsWeb) return null;

    final runtimeValue = Platform.environment[_envVarName];
    if (runtimeValue != null && runtimeValue.isNotEmpty) {
      return runtimeValue;
    }

    const compileTimeValue = String.fromEnvironment(_envVarName);
    if (compileTimeValue.isNotEmpty) {
      return compileTimeValue;
    }

    return null;
  }
}
