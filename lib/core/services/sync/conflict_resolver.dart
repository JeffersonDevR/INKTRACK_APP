/// Last-write-wins conflict resolution helper for cloud sync.
///
/// Determines whether a server-side record should override the local
/// version based on `updated_at` timestamps and local sync status.
class ConflictResolver {
  /// Returns `true` if a server download should be skipped because
  /// the local record has pending changes or is newer.
  ///
  /// [localSyncStatus] - e.g. `'synced'`, `'pending'`, `'pending_upload'`
  /// [localLastSyncedAt] - when the local record was last synced
  /// [serverUpdatedAt] - the server record's last update timestamp
  static bool shouldSkipDownload({
    required String? localSyncStatus,
    required DateTime? localLastSyncedAt,
    required DateTime? serverUpdatedAt,
  }) {
    // If the record doesn't exist locally, always accept the server version.
    if (localSyncStatus == null) return false;

    // Never overwrite a local pending upload.
    if (localSyncStatus != 'synced') return true;

    // If both timestamps are available, keep the newer one.
    if (serverUpdatedAt != null && localLastSyncedAt != null) {
      // Local was synced after the server update → keep local.
      if (localLastSyncedAt.isAfter(serverUpdatedAt)) return true;
    }

    return false;
  }

  /// Parse a value that may be a [String], [DateTime], or `null`.
  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
