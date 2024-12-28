import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    debugPrint('Initializing NotificationService');
    
    // Ensure Firebase is initialized
    if (!Firebase.apps.isNotEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    // Request permission and log result
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Notification permission status: ${settings.authorizationStatus}');

    // Initialize local notifications
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Set up message handlers
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Received foreground message: ${message.messageId}');
      _handleForegroundMessage(message);
    });

    // Subscribe to topics and log results
    await _subscribeToTopics();

    // Get the FCM token and log it
    final token = await _fcm.getToken();
    debugPrint('FCM Token: $token');
  }

  Future<void> _subscribeToTopics() async {
    try {
      await _fcm.subscribeToTopic('news');
      debugPrint('Successfully subscribed to news topic');
      await _fcm.subscribeToTopic('matches');
      await _fcm.subscribeToTopic('transfers');
      await _fcm.subscribeToTopic('general');
    } catch (e) {
      debugPrint('Error subscribing to topics: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    await _showLocalNotification(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    debugPrint('Received notification: ${message.notification?.title}');
    debugPrint('Notification data: ${message.data}');

    final androidDetails = AndroidNotificationDetails(
      'dunbeholden_channel',
      'Dunbeholden Updates',
      channelDescription: 'Important updates from Dunbeholden FC',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    var details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _localNotifications.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        details,
        payload: message.data['route'],
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped with payload: ${response.payload}');
    if (response.payload != null) {
      // You'll need to implement this navigation method
      _handleNavigation(response.payload!);
    }
  }

  void _handleNavigation(String route) {
    // Implement navigation logic here
    // You might want to use a navigation service or pass a navigation function
    // Example:
    // if (route == '/news-detail') {
    //   // Navigate to news detail
    // }
  }

  Future<void> _handleInitialMessage(RemoteMessage? message) async {
    if (message != null) {
      // Handle notification that opened the app
      // You'll need to implement navigation logic here
    }
  }
}

// This needs to be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background messages
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Handle background messages
  debugPrint('Handling background message: ${message.messageId}');
} 