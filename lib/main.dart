import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'widgets/custom_bottom_navigation_bar.dart';
import 'screens/news_detail_screen.dart';
import 'config/theme.dart';

import 'screens/onboarding_screen.dart';

import 'services/notification_service.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'services/image_cache_service.dart';
import 'services/shader_warmer.dart';
import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Check if this is first launch
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;

    // Initialize Firebase
    await Firebase.initializeApp();
    
    // Initialize Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    
    // Initialize notifications without permission check
    final notificationService = NotificationService();
    await notificationService.initializeWithoutPermissionCheck();

    // More aggressive memory limits
    imageCache.maximumSize = 50;
    imageCache.maximumSizeBytes = 30 * 1024 * 1024;

    try {
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
          child: MaterialApp(
            title: 'Dunbeholden FC',
            theme: AppTheme.theme,
            home: hasCompletedOnboarding 
                ? const MainScreen() 
                : const OnboardingScreen(),
          ),
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
  const MyApp({super.key, this.notificationService, this.initialRoute});
  final NotificationService? notificationService;
  final String? initialRoute;

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

