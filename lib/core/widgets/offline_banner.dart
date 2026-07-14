import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:InkTrack/core/services/connectivity_service.dart';
import 'package:InkTrack/core/services/auth_service.dart';
import 'package:InkTrack/features/sync/presentation/viewmodels/sync_queue_viewmodel.dart';
import 'package:InkTrack/l10n/app_localizations.dart';

/// A persistent banner indicating the app is operating in offline mode
/// or has pending sync changes.
///
/// Uses [ConnectivityService] for real-time connectivity detection and
/// wraps content in [SafeArea] to avoid system UI overlap.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService =
        Provider.of<ConnectivityService?>(context, listen: true);
    final authService = Provider.of<AuthService?>(context, listen: true);
    final syncQueueVM = Provider.of<SyncQueueViewModel?>(context, listen: true);

    // ConnectivityService is the source of truth when available.
    // Only fall back to authService.offlineMode when there's no connectivity service.
    final hasConnectivityService = connectivityService != null;
    final isOffline = hasConnectivityService
        ? !connectivityService!.isOnline
        : (authService?.offlineMode ?? false);
    final pendingCount = syncQueueVM?.pendingCount ?? 0;

    final showBanner = isOffline || pendingCount > 0;

    if (!showBanner) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final text = pendingCount > 0
        ? l10n.offlineBannerPending(pendingCount)
        : l10n.offlineBannerTitle;

    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.amber.shade800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

