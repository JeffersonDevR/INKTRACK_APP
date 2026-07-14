import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/l10n/app_localizations.dart';
import 'package:InkTrack/features/sync/presentation/viewmodels/sync_queue_viewmodel.dart';
import 'package:InkTrack/core/theme/app_theme.dart';

class SyncBadge extends StatelessWidget {
  const SyncBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<SyncQueueViewModel>(
      builder: (context, vm, child) {
        if (!vm.syncService.isEnabled) {
          return const SizedBox.shrink();
        }

        if (vm.pendingCount == 0 &&
            !vm.isRunning &&
            vm.lastSyncResult?.outcome != SyncOutcome.error) {
          return const SizedBox.shrink();
        }

        Color bgColor = AppTheme.primaryColor;
        Widget textWidget;
        bool showRetry = false;

        if (vm.isRunning) {
          textWidget = Text(
            l10n.syncStateSyncing,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          );
        } else if (vm.lastSyncResult?.outcome == SyncOutcome.error) {
          bgColor = AppTheme.errorColor;
          textWidget = Text(
            l10n.syncStateError,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          );
          showRetry = true;
        } else {
          bgColor = Colors.orange;
          textWidget = Text(
            l10n.syncStatePendingCount(vm.pendingCount),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              textWidget,
              if (showRetry) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => vm.triggerSync(),
                  child: Text(
                    l10n.syncRetryAction.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => vm.triggerSync(),
                  child: const Icon(
                    Icons.sync,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
