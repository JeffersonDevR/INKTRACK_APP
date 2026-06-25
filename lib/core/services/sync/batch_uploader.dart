import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:InkTrack/core/data/local/database.dart';
import 'package:InkTrack/core/services/log_service.dart';
import 'package:InkTrack/core/services/sync/sync_strategy.dart';

/// Uploads pending records in configurable batches with
/// exponential-backoff retry.
class BatchUploader {
  final int batchSize;
  final int maxRetries;
  final Duration initialDelay;

  BatchUploader({
    this.batchSize = 50,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  });

  /// Upload all pending rows for [strategy] in batches.
  ///
  /// Returns the total number of successfully uploaded rows.
  Future<int> uploadPending(
    AppDatabase db,
    SupabaseClient client,
    SyncStrategy strategy,
  ) async {
    final log = LogService.instance;
    final rows = await strategy.getPendingRows(db);
    if (rows.isEmpty) {
      log.debug('Batch', 'No pending rows for ${strategy.tableName}');
      return 0;
    }

    log.info('Batch', 'Uploading ${rows.length} rows to ${strategy.tableName} in batches of $batchSize');
    int uploaded = 0;

    for (var i = 0; i < rows.length; i += batchSize) {
      final end = (i + batchSize > rows.length) ? rows.length : i + batchSize;
      final batch = rows.sublist(i, end);

      final success = await _uploadWithRetry(client, strategy, batch);
      if (success) {
        final ids = batch.map((r) => r['id'] as String).toList();
        await strategy.markAsSynced(db, ids);
        uploaded += batch.length;
        log.debug('Batch', 'Batch ${i ~/ batchSize + 1}/${(rows.length / batchSize).ceil()} OK for ${strategy.tableName}');
      } else {
        log.error('Batch', 'Batch ${i ~/ batchSize + 1} FAILED for ${strategy.tableName} after all retries');
      }
    }

    log.info('Batch', 'Finished uploading $uploaded/${rows.length} rows to ${strategy.tableName}');
    return uploaded;
  }

  /// Attempt a single batch upload with exponential backoff.
  Future<bool> _uploadWithRetry(
    SupabaseClient client,
    SyncStrategy strategy,
    List<Map<String, dynamic>> batch,
  ) async {
    final log = LogService.instance;
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await strategy.uploadBatch(client, batch);
      } catch (e) {
        log.warning('Batch', 'Attempt ${attempt + 1}/$maxRetries failed for ${strategy.tableName}: $e');
        if (attempt == maxRetries - 1) rethrow;

        final delay = initialDelay * pow(2, attempt).toInt();
        await Future.delayed(delay);
      }
    }
    return false;
  }
}
