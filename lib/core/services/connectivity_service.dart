// lib/core/services/connectivity_service.dart

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class ConnectivityService {
  // 1. Singleton boilerplate
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  static ConnectivityService get instance => _instance;

  final Logger _log = Logger('ConnectivityService');
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();
  final Connectivity _connectivity = Connectivity();

  bool _isConnected = true;

  // ← Now listens to List<ConnectivityResult>
  StreamSubscription<List<ConnectivityResult>>? _networkSubscription;
  Timer? _periodicTimer;
  Timer? _retryTimer;

  ConnectivityService._internal() {
    debugPrint('ConnectivityService initialized');
  }

  /// Expose a boolean stream of connectivity changes
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;
  bool get isConnected => _isConnected;

  /// Call once (e.g. in main()) to begin monitoring
  void startMonitoring() {
    _log.info('Starting connectivity monitoring');
    _stopAll();

    // Immediate check
    checkConnection();

    // Listen for interface changes (List<ConnectivityResult>)
    _networkSubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      _log.fine('Plugin reports interfaces: $results');
      // Always do a real-world check, even if plugin says none
      checkConnection();
    });

    // Poll every 5s as a safety net
    _periodicTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => checkConnection(),
    );
  }

  /// A true “are we online?” test: DNS socket + HTTP fallback
  Future<bool> checkConnection() async {
    _log.fine('Running real-world connectivity check…');

    bool connected = false;

    // 1️⃣ DNS socket test
    try {
      final socket = await Socket.connect(
        '8.8.8.8',
        53,
        timeout: const Duration(seconds: 1),
      );
      socket.destroy();
      connected = true;
      _log.fine('✅ DNS socket succeeded');
    } catch (e) {
      _log.fine('⚠️ DNS socket failed: $e');
    }

    // 2️⃣ HTTP GET fallback
    if (!connected) {
      try {
        final client =
            HttpClient()..connectionTimeout = const Duration(seconds: 2);
        final request = await client
            .getUrl(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 2));
        final response = await request.close().timeout(
          const Duration(seconds: 2),
        );
        await response.drain<void>();
        client.close();
        connected = true;
        _log.fine('✅ HTTP fallback succeeded');
      } catch (e) {
        _log.fine('⚠️ HTTP fallback failed: $e');
      }
    }

    // 3️⃣ Update state & notify if changed
    _updateStatus(connected);

    // 4️⃣ If still false, schedule a quick retry
    if (!connected) {
      _retryTimer?.cancel();
      _retryTimer = Timer(const Duration(seconds: 2), checkConnection);
    }

    return connected;
  }

  /// Fire an on-demand check from your UI’s “Try Again”
  Future<bool> forceCheck() => checkConnection();

  void _updateStatus(bool connected) {
    if (_isConnected != connected) {
      _log.info('Connectivity changed: $_isConnected → $connected');
      _isConnected = connected;
      _connectivityController.add(connected);
    }
  }

  /// Stop all listeners & timers
  void stopMonitoring() {
    _log.info('Stopping connectivity monitoring');
    _stopAll();
  }

  void _stopAll() {
    _networkSubscription?.cancel();
    _periodicTimer?.cancel();
    _retryTimer?.cancel();
    _networkSubscription = null;
    _periodicTimer = null;
    _retryTimer = null;
  }

  /// Clean up when done
  void dispose() {
    _stopAll();
    _connectivityController.close();
  }
}
