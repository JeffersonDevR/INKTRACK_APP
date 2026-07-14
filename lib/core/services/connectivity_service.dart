import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Reactive connectivity monitor wrapping [connectivity_plus].
///
/// Exposes an [onlineStream] that emits `true` when the device has network
/// connectivity and `false` when it does not. Also provides a synchronous
/// [isOnline] getter reflecting the last known state.
class ConnectivityService {
  final Connectivity _connectivity;
  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  /// Creates the service and starts listening to connectivity changes.
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
  }

  /// Last known connectivity state.
  bool get isOnline => _isOnline;

  /// Stream that emits `true` when online, `false` when offline.
  Stream<bool> get onlineStream => _controller.stream;

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    // If any result indicates connectivity, we're online
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online != _isOnline) {
      _isOnline = online;
      _controller.add(online);
    }
  }

  /// Cancels the subscription and closes the stream controller.
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
