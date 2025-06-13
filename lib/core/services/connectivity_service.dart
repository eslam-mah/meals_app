import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class ConnectivityService {
  // Singleton pattern
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  static ConnectivityService get instance => _instance;
  
  ConnectivityService._internal() {
    debugPrint('ConnectivityService initialized');
  }

  // Stream controller for broadcasting connectivity status
  final _connectivityController = StreamController<bool>.broadcast();
  
  // Public stream to listen for connectivity changes
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;
  
  // Current connection status
  bool _isConnected = true;
  bool get isConnected => _isConnected;
  
  // Connectivity plugin
  final Connectivity _connectivity = Connectivity();
  
  // Subscriptions and timers
  StreamSubscription? _networkSubscription;
  Timer? _periodicCheckTimer;
  Timer? _checkConnectionRetryTimer;

  /// Starts monitoring connectivity
  void startMonitoring() {
    debugPrint('Starting connectivity monitoring');
    
    // Clean up existing subscriptions first
    _stopTimersAndSubscriptions();
    
    // Perform an immediate check
    checkConnection();
    
    // Set up a listener for network interface changes
    _networkSubscription = _connectivity.onConnectivityChanged.listen((results) {
      debugPrint('Network change detected: $results');
      
      // If we have no connectivity at all
      if (results.every((result) => result == ConnectivityResult.none)) {
        debugPrint('All network interfaces are down, marking as disconnected');
        _updateConnectionStatus(false);
      } else {
        // We have some network, verify internet
        checkConnection();
      }
    });
    
    // Set up periodic check every 5 seconds
    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      checkConnection();
    });
    
    debugPrint('Connectivity monitoring started');
  }
  
  /// Check current internet connection 
  Future<bool> checkConnection() async {
    // First check if device has network connectivity
    final connectivityResults = await _connectivity.checkConnectivity();
    final hasNetworkConnection = connectivityResults.any((result) => result != ConnectivityResult.none);
    
    if (!hasNetworkConnection) {
      debugPrint('No network connection, definitely disconnected');
      _updateConnectionStatus(false);
      return false;
    }
    
    // Try to connect to Google DNS - this is very fast
    try {
      final socket = await Socket.connect('8.8.8.8', 53, timeout: const Duration(seconds: 1));
      socket.destroy();
      debugPrint('Socket connection to Google DNS successful - internet is connected');
      _updateConnectionStatus(true);
      return true;
    } catch (e) {
      debugPrint('Socket connection to Google DNS failed, trying HTTP');
      // Continue to HTTP check
    }
    
    // Try an HTTP request as fallback
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      
      final request = await client.getUrl(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 2));
          
      final response = await request.close().timeout(const Duration(seconds: 2));
      
      await response.drain<void>();
      client.close();
      
      debugPrint('HTTP request successful - internet is connected');
      _updateConnectionStatus(true);
      return true;
    } catch (e) {
      debugPrint('HTTP request failed, internet appears to be disconnected: $e');
      _updateConnectionStatus(false);
      
      // Schedule a retry soon to confirm disconnection
      _scheduleRetryCheck();
      
      return false;
    }
  }
  
  // Schedule a quick retry to verify disconnection
  void _scheduleRetryCheck() {
    _checkConnectionRetryTimer?.cancel();
    _checkConnectionRetryTimer = Timer(const Duration(seconds: 2), () {
      checkConnection();
    });
  }
  
  // Update connection status and notify listeners if changed
  void _updateConnectionStatus(bool connected) {
    if (_isConnected != connected) {
      debugPrint('Connection status changed: $_isConnected -> $connected');
      _isConnected = connected;
      _connectivityController.add(connected);
    }
  }
  
  /// Force a connectivity check and return the result
  Future<bool> forceCheck() async {
    debugPrint('Forcing connectivity check');
    return checkConnection();
  }
  
  /// Stop monitoring connectivity
  void stopMonitoring() {
    debugPrint('Stopping connectivity monitoring');
    _stopTimersAndSubscriptions();
  }
  
  /// Clean up timers and subscriptions
  void _stopTimersAndSubscriptions() {
    _networkSubscription?.cancel();
    _networkSubscription = null;
    
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = null;
    
    _checkConnectionRetryTimer?.cancel();
    _checkConnectionRetryTimer = null;
  }
  
  /// Clean up resources when the service is no longer needed
  void dispose() {
    debugPrint('Disposing ConnectivityService');
    _stopTimersAndSubscriptions();
    _connectivityController.close();
  }
} 