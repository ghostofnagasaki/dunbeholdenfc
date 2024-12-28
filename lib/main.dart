import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'widgets/custom_bottom_navigation_bar.dart';
import 'screens/news_detail_screen.dart';
import 'config/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase first
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');

    // Get FCM token after Firebase is initialized
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $fcmToken');

    // Initialize notifications
    final notificationService = NotificationService();
    await notificationService.initialize();

    runApp(
      ProviderScope(
        child: MyApp(notificationService: notificationService),
      ),
    );
  } catch (e) {
    debugPrint('Initialization error: $e');
    // Still run the app even if there's an error
    runApp(
      const ProviderScope(
        child: MyApp(notificationService: null),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.notificationService});

  final NotificationService? notificationService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dunbeholden FC',
      theme: AppTheme.theme,
      home: const MainScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/news-detail') {
          final postId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => NewsDetailScreen(postId: postId),
          );
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const MainScreen(),
        );
      },
    );
  }
}

