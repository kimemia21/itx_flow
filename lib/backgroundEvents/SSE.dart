import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ServerSideEventManager {
  // Singleton instance
  static final ServerSideEventManager _instance = ServerSideEventManager._internal();
  factory ServerSideEventManager() => _instance;
  ServerSideEventManager._internal();

  // Core components
  final Logger _logger = Logger();
  final Dio _dio = Dio();
  final Connectivity _connectivity = Connectivity();

  // Event stream controllers
  final StreamController<dynamic> _eventController = StreamController.broadcast();
  Stream<dynamic> get eventStream => _eventController.stream;

  // Connection variables
  StreamSubscription? _connectionSubscription;
  Timer? _reconnectTimer;
  bool _isConnecting = false;

  // Configuration
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 2);

  /// Establish SSE Connection
  Future<void> connectToSSE({
    required String url,
    Map<String, dynamic>? headers,
  }) async {
    // Prevent multiple simultaneous connection attempts
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      // Check network connectivity
      var connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        _logger.w('No network connection. Waiting for network...');
        _setupConnectivityListener(url, headers);
        return;
      }

     

      // Cancel existing connection
      await _connectionSubscription?.cancel();

      // Prepare connection
      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            ...?headers,
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
        ),
      );

      // Listen to event stream
      _connectionSubscription = response.data.stream.listen(
        (chunk) {
          final event = String.fromCharCodes(chunk);
          _processServerEvent(event);
        },
        onDone: () => _handleConnectionClosure(url, headers),
        
        onError: (error) => _handleConnectionError(error, url, headers),
        cancelOnError: false,
      );

      _logger.i('SSE Connection established successfully');
    } catch (e) {
      _logger.e('SSE Connection Error: $e');
      _scheduleReconnect(url, headers);
    } finally {
      _isConnecting = false;
    }
  }

  /// Setup Connectivity Listener
  void _setupConnectivityListener(String url, Map<String, dynamic>? headers) {
    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        connectToSSE(url: url, headers: headers);
      }
    });
  }

  /// Process Incoming Server Events
  void _processServerEvent(String event) {
    try {
      // Basic event parsing (customize based on your server's event format)
      if (event.contains('data:')) {
        final data = event.split('data:')[1].trim();
        _eventController.add(data);
        _logger.d('Received Event: $data');

        // Notify background service about the event
        _notifyBackgroundService(data);
      }
    } catch (e) {
      _logger.e('Event Processing Error: $e');
    }
  }

  /// Notify Background Service
  void _notifyBackgroundService(dynamic eventData) {
    final service = FlutterBackgroundService();
    service.invoke('onEvent', {
      'event': eventData.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }


  void _handleConnectionClosure(String url, Map<String, dynamic>? headers) {
    _logger.w('SSE Connection closed unexpectedly');
    _scheduleReconnect(url, headers);
  }

  /// Handle Connection Errors
  void _handleConnectionError(
    dynamic error, 
    String url, 
    Map<String, dynamic>? headers
  ) {
    _logger.e('SSE Connection Error: $error');
    _scheduleReconnect(url, headers);
  }

  /// Reconnection Strategy
  void _scheduleReconnect(String url, Map<String, dynamic>? headers) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      _logger.i('Attempting to reconnect...');
      connectToSSE(url: url, headers: headers);
    });
  }

  /// Initialize Background Service
  static Future<void> initializeBackgroundService(String sseUrl) async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: _onBackgroundServiceStart,
        autoStart: true,
        isForegroundMode: true,


        // foregroundServiceNotificationTitle: 'SSE Background Service',
        // foregroundServiceNotificationContent: 'Maintaining SSE Connection',
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onBackground: _onIosBackground,
        onForeground: _onBackgroundServiceStart,
      ),
    );

    // Store SSE URL for background service
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sse_background_url', sseUrl);

    // Start the service
    service.startService();
  }

  /// Background Service Start Handler for Android and iOS Foreground
  @pragma('vm:entry-point')
  static void _onBackgroundServiceStart(ServiceInstance service) async {
    // Only for Android
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground')!.listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground')!.listen((event) {
        service.setAsBackgroundService();
      });
    }

    // Shared handlers
    service.on('stopService')!.listen((event) {
      service.stopSelf();
    });

    // Retrieve SSE URL from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final sseUrl = prefs.getString('sse_background_url');

    if (sseUrl != null) {
      // Maintain SSE Connection in Background
      _maintainBackgroundSSEConnection(sseUrl);
    }
  }

  /// Background SSE Connection Maintenance
  static Future<void> _maintainBackgroundSSEConnection(String sseUrl) async {
    final logger = Logger();
    final dio = Dio();

    try {
      final response = await dio.get(
        sseUrl,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
        ),
      );

      await for (var chunk in response.data.stream) {
        final event = String.fromCharCodes(chunk);
        logger.d('Background SSE Event: $event');

        // Optionally store or process background events
        // You can add local storage, notifications, etc.
      }
    } catch (e) {
      logger.e('Background SSE Connection Error: $e');
      
      // Retry connection after delay
      await Future.delayed(Duration(seconds: 10));
      _maintainBackgroundSSEConnection(sseUrl);
    }
  }

  /// iOS Background Handler
  @pragma('vm:entry-point')
  static Future<bool> _onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }

  /// Cleanup Method
  void dispose() {
    _connectionSubscription?.cancel();
    _reconnectTimer?.cancel();
    _eventController.close();
  }
}

// Usage in your main app
class SSEBackgroundServiceExample extends StatefulWidget {
  @override
  _SSEBackgroundServiceExampleState createState() => _SSEBackgroundServiceExampleState();
}

class _SSEBackgroundServiceExampleState extends State<SSEBackgroundServiceExample> {
  final ServerSideEventManager _sseManager = ServerSideEventManager();
  List<String> _receivedEvents = [];

  @override
  void initState() {
    super.initState();
    _initializeSSEConnection();
  }

  void _initializeSSEConnection() {
    // Replace with your actual SSE endpoint
    const String sseUrl = 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=usd';
    
    // Initialize Background Service
    ServerSideEventManager.initializeBackgroundService(sseUrl);
    
    // Connect to SSE
    _sseManager.connectToSSE(url: sseUrl);

    // Listen to events
    _sseManager.eventStream.listen((event) {
      setState(() {
        _receivedEvents.add(event.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SSE Background Service')),
      body: ListView.builder(
        itemCount: _receivedEvents.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_receivedEvents[index]),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _sseManager.dispose();
    super.dispose();
  }
}