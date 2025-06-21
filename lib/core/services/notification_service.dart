import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:meals_app/generated/l10n.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final Logger _logger = Logger('NotificationService');
  
  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    _logger.info('Initializing notification service');
    
    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    // Initialization settings for both platforms
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
    
    // Request permission immediately
    _requestNotificationPermissions();
    
    _logger.info('Notification service initialized');
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    _logger.info('Notification clicked: ${response.payload}');
    // Handle notification tap here if needed
  }

  // Request permissions for both platforms
  Future<void> _requestNotificationPermissions() async {
    _logger.info('Requesting notification permissions');
    
    // For Android
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      _logger.info('Requesting Android notification permissions');
      final bool? granted = await androidImplementation.requestNotificationsPermission();
      _logger.info('Android notification permission granted: $granted');
    }

    // For iOS
    final IOSFlutterLocalNotificationsPlugin? iOSImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();

    if (iOSImplementation != null) {
      _logger.info('Requesting iOS notification permissions');
      final bool? result = await iOSImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      _logger.info('iOS notification permission result: $result');
    }
  }
  
  // Show order confirmation notification
  Future<void> showOrderConfirmationNotification(BuildContext context) async {
    _logger.info('Attempting to show order confirmation notification');
    
    // Get localized strings based on current context
    final S localization = S.of(context);
    
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'Notifications related to orders',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const DarwinNotificationDetails iOSNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );
    
    try {
      _logger.info('Showing notification with title: ${localization.orderReadyNotificationTitle}');
      _logger.info('Notification body: ${localization.orderReadyNotificationBody}');
      
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond, // Random ID based on current time
        localization.orderReadyNotificationTitle,
        localization.orderReadyNotificationBody,
        notificationDetails,
      );
      
      _logger.info('Order confirmation notification request completed');
    } catch (e) {
      _logger.severe('Error showing notification: $e');
    }
  }
} 