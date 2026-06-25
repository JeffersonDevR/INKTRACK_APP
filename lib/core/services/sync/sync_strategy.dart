import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:InkTrack/core/data/local/database.dart';

/// Abstract interface for per-table sync strategies.
///
/// Each strategy knows how to:
/// - Find pending uploads for its table
/// - Convert local records to JSON for Supabase
/// - Convert Supabase JSON rows back to local companions
/// - Mark records as synced after upload
/// - Resolve conflicts by comparing [updatedAt] timestamps
abstract class SyncStrategy {
  /// The Supabase table name (e.g. `'productos'`).
  String get tableName;

  /// Query local records that need uploading
  /// (syncStatus != 'synced').
  Future<List<Map<String, dynamic>>> getPendingRows(AppDatabase db);

  /// Mark a list of record IDs as synced.
  Future<void> markAsSynced(AppDatabase db, List<String> ids);

  /// Fetch all rows from Supabase and apply them locally
  /// with last-write-wins conflict resolution.
  ///
  /// Returns the number of records applied.
  Future<int> downloadAndMerge(AppDatabase db, SupabaseClient client);

  /// Upsert a single batch of rows to Supabase.
  /// Returns `true` if the batch succeeded.
  Future<bool> uploadBatch(
    SupabaseClient client,
    List<Map<String, dynamic>> rows,
  );
}
