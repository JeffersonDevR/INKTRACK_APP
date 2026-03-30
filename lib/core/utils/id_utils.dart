import 'package:uuid/uuid.dart';

class IdUtils {
  static const _uuid = Uuid();

  /// Generates a unique UUID v4
  static String generateId() {
    return _uuid.v4();
  }

  /// Generates a timestamp-based ID (fallback/sequential)
  static String generateTimestampId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
