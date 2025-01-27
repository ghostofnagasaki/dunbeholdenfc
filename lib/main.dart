import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

const bool debug = !kReleaseMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();

  // Enable persistence
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  
  // Check if this is first launch
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;

  // Initialize Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  // Initialize notifications without permission check
  final notificationService = NotificationService();
  await notificationService.initializeWithoutPermissionCheck();

  // More aggressive memory limits
  imageCache.maximumSize = 50;
  imageCache.maximumSizeBytes = 30 * 1024 * 1024;

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  );

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

    runApp(const ProviderScope(child: MyApp()));
  } catch (e, stack) {
    FirebaseCrashlytics.instance.recordError(e, stack);
    debugPrint('Initialization error: $e');
    runApp(const ProviderScope(child: MyApp()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dunbeholden FC',
      theme: AppTheme.theme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return const MainScreen();
        },
      ),
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

