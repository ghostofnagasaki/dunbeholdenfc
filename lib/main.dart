import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';


import 'widgets/custom_bottom_navigation_bar.dart';
import 'screens/news_detail_screen.dart';
import 'config/theme.dart';

import 'services/notification_service.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'services/image_cache_service.dart';
import 'services/shader_warmer.dart';
import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // Initialize notifications early
    final notificationService = NotificationService();
    await notificationService.initialize();

    // More aggressive memory limits
    imageCache.maximumSize = 50;
    imageCache.maximumSizeBytes = 30 * 1024 * 1024;

    try {
      // Initialize Crashlytics
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      
      // Catch errors that happen outside of Flutter
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // Warm up shaders before showing the app
      await ShaderWarmer.warmupShaders();
      
      // Only enable performance monitoring in non-test environment
      if (!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
        await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
      }

      // Pre-cache common images
      await ImageCacheService.preCacheImages([
        'assets/icons/dunbeholden.png',
        // Add other frequently used images
      ]);

      runApp(
        ProviderScope(
          child: MyApp(notificationService: notificationService),
        ),
      );
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      debugPrint('Initialization error: $e');
      runApp(const ProviderScope(child: MyApp()));
    }
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.notificationService});
  final NotificationService? notificationService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkNotifications();
  }

  Future<void> _checkNotifications() async {
    if (widget.notificationService != null) {
      await Future.delayed(const Duration(seconds: 1)); // Wait for app to settle
      if (mounted) {
        await widget.notificationService!.checkAndRequestPermissions(context);
      }
    }
  }

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

