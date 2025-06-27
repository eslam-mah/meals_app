import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final Logger _logger = Logger('NotificationService');
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

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
    const InitializationSettings initializationSettings =
        InitializationSettings(
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

    // Handle notification tap based on payload
    if (response.payload == 'feedback') {
      _logger.info('Navigating to feedback page');
      final context = navigatorKey.currentContext;
      if (context != null) {
        GoRouter.of(context).push('/feedback');
      }
    }
  }

  // Request permissions for both platforms
  Future<void> _requestNotificationPermissions() async {
    _logger.info('Requesting notification permissions');

    // For Android
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      _logger.info('Requesting Android notification permissions');
      final bool? granted =
          await androidImplementation.requestNotificationsPermission();
      _logger.info('Android notification permission granted: $granted');
    }

    // For iOS
    final IOSFlutterLocalNotificationsPlugin? iOSImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

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
  Future<void> showOrderConfirmationNotificationWithStrings({
    required String title,
    required String body,
  }) async {
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

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
    );
  }

  // Show feedback request notification
  Future<void> showFeedbackRequestNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'feedback_channel',
          'Feedback Notifications',
          channelDescription: 'Notifications related to feedback requests',
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

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: 'feedback',
    );
  }
}
