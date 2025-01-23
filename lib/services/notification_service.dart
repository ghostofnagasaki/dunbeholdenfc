import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<bool> areNotificationsEnabled() async {
    final settings = await _fcm.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> checkAndRequestPermissions(BuildContext context) async {
    final enabled = await areNotificationsEnabled();
    if (!enabled && context.mounted) {
      // Ensure we're in a MaterialApp context
      if (context.findAncestorWidgetOfExactType<MaterialApp>() != null) {
        final shouldAsk = await _showNotificationDialog(context);
        if (shouldAsk == true) {
          await requestPermissions();
        }
      }
    }
  }

  Future<bool?> _showNotificationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => MaterialApp(
        home: AlertDialog(
          title: const Text('Enable Notifications'),
          content: const Text(
            'Stay updated with the latest news, match updates, and announcements from Dunbeholden FC.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Not Now'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Enable'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initialize() async {
    debugPrint('Initializing NotificationService');
    
    // Configure notification channels for Android
    await _configureAndroidChannel();
    await _initializeLocalNotifications();

    // Request permission immediately
    await requestPermissions();

    // Set up message handlers with debug logs
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Received foreground message: ${message.toMap()}');
      _handleForegroundMessage(message);
    });
    
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Get FCM token and log it
    final token = await _fcm.getToken();
    debugPrint('FCM Token: $token');

    // Subscribe to topics immediately if permitted
    final settings = await _fcm.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _subscribeToTopics();
    }
  }

  Future<void> initializeWithoutPermissionCheck() async {
    debugPrint('Initializing NotificationService');
    
    // Configure notification channels for Android
    await _configureAndroidChannel();
    await _initializeLocalNotifications();

    // Set up message handlers with debug logs
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Received foreground message: ${message.toMap()}');
      _handleForegroundMessage(message);
    });
    
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Get FCM token and log it
    final token = await _fcm.getToken();
    debugPrint('FCM Token: $token');
  }

  Future<void> requestPermissions() async {
    // Request permission with sound and badge
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('Notification permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Subscribe to topics only after permission is granted
      await _subscribeToTopics();
    }
  }

  Future<void> _configureAndroidChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'live_match_channel', // Update to match Cloud Functions
      'Live Match Updates',
      description: 'Real-time updates for live matches',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Add high importance channel
    const highImportanceChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'Important Updates',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(highImportanceChannel);
  }

  Future<void> _initializeLocalNotifications() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) => _handleNotificationTap(details.payload),
    );
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Handling foreground message: ${message.notification?.title}');
    
    try {
      await _showLocalNotification(
        title: message.notification?.title ?? 'New Update',
        body: message.notification?.body ?? '',
        payload: message.data['postId'] ?? message.data['matchId'],
        channelId: message.data['type'] == 'match_commentary' 
            ? 'live_match_channel' 
            : 'high_importance_channel',
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    required String channelId,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId == 'live_match_channel' ? 'Live Match Updates' : 'Important Updates',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      // Navigate to post detail
      // You'll need to implement navigation logic here
    }
  }

  Future<void> _subscribeToTopics() async {
    await _fcm.subscribeToTopic('posts');
    await _fcm.subscribeToTopic('news');
    await _fcm.subscribeToTopic('announcements');
    await _fcm.subscribeToTopic('live_matches');
    await _fcm.subscribeToTopic('match_commentary');
  }

  // void _handleMessage(RemoteMessage message) {
  //   if (message.data['postId'] != null) {
  //     // Handle navigation to post
  //   }
  // }

  Future<void> _showMatchCommentaryNotification({
    required String matchId,
    required String commentary,
    String? minute,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'live_match_channel',
      'Live Match Updates',
      channelDescription: 'Real-time updates for live matches',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    final title = minute != null ? '$minute\' Match Update' : 'Match Update';

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      commentary,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: 'match:$matchId',
    );
  }
}

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
} 