import 'package:uuid/uuid.dart';

/// Centralized ID generation for local entities.
///
/// Supabase primary keys are UUIDs, so local IDs are generated as UUID v4
/// strings and stored in Drift [text()] columns. This keeps local and remote
/// identifiers compatible without type conversion during sync.
class IdUtils {
  static const _uuid = Uuid();

  /// Generates a UUID v4 suitable for use as a primary key both locally and
  /// in Supabase.
  static String generateId() {
    return _uuid.v4();
  }

  /// Generates a timestamp-based ID.
  ///
  /// @deprecated Use [generateId] for all entity primary keys. Timestamp IDs
  /// are kept only for legacy/test data that explicitly requires them.
  @Deprecated('Use generateId() for primary keys to match Supabase UUIDs')
  static String generateTimestampId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
