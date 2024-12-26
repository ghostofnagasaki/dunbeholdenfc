import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:dunbeholden/screens/home_screen.dart';
import 'package:dunbeholden/providers/post_provider.dart';
import 'package:dunbeholden/screens/settings_screen.dart';
import 'package:intl/intl.dart';
import 'package:clock/clock.dart';
import 'dart:async';

void main() {
  final testAnnouncement = Post(
    id: 'announcement-1',
    title: 'Important Announcement',
    content: 'Test Announcement Content',
    summary: 'Test Summary',
    category: 'Announcement',
    date: DateTime(2024, 1, 1, 12, 30),
    image: 'https://example.com/announcement.jpg',
    author: 'Test Author',
    featured: true,
    seoDescription: 'Test SEO',
    slug: 'test-announcement',
    status: 'published',
    tags: ['announcement'],
  );

  final testRegularPost = Post(
    id: 'post-1',
    title: 'Regular Post',
    content: 'Test Post Content',
    summary: 'Test Summary',
    category: 'News',
    date: DateTime(2024, 1, 1, 14, 30),
    image: 'https://example.com/post.jpg',
    author: 'Test Author',
    featured: false,
    seoDescription: 'Test SEO',
    slug: 'test-post',
    status: 'published',
    tags: ['news'],
  );

  testWidgets('HomeScreen shows loading state', (WidgetTester tester) async {
    final completer = Completer<List<Post>>();
    
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith((ref) => Stream.fromFuture(completer.future)),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('HomeScreen shows empty state when no posts',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('No posts available'), findsOneWidget);
    });
  });

  testWidgets('HomeScreen shows error state', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.error('Test error'),
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Error: Test error'), findsOneWidget);
    });
  });

  testWidgets('HomeScreen displays announcement and regular posts',
      (WidgetTester tester) async {
    final fixedTime = DateTime(2024, 1, 1, 15, 0);
    final twoHoursAgo = fixedTime.subtract(const Duration(hours: 2));
    final testAnnouncement = testRegularPost.copyWith(
      id: 'announcement-1',
      title: 'Announcement',
      featured: true,
      date: twoHoursAgo,
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.value([testAnnouncement, testRegularPost]),
            ),
          ],
          child: MaterialApp(
            home: HomeScreen(
              getCurrentTime: () => fixedTime,
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify announcement card
      expect(find.text('Announcement'), findsOneWidget);
      expect(find.text('• 2h ago'), findsOneWidget);

      // Verify regular post card
      expect(find.text('Regular Post'), findsOneWidget);
    });
  });

  testWidgets('HomeScreen displays only regular posts when no announcements',
      (WidgetTester tester) async {
    final fixedTime = DateTime(2024, 1, 1, 15, 0);
    final thirtyMinutesAgo = fixedTime.subtract(const Duration(minutes: 30));
    final testPost = testRegularPost.copyWith(date: thirtyMinutesAgo);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith((ref) => Stream.value([testPost])),
          ],
          child: MaterialApp(
            home: HomeScreen(
              getCurrentTime: () => fixedTime,
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text("Men's Team • 30m ago"), findsOneWidget);
      expect(find.text('Regular Post'), findsOneWidget);
    });
  });

  testWidgets('HomeScreen navigates to settings when icon is tapped',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: MaterialApp(
            routes: {
              '/settings': (context) => const SettingsScreen(),
            },
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Verify navigation to settings screen
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });

  testWidgets('HomeScreen post cards are tappable', (WidgetTester tester) async {
    String? navigatedPostId;
    
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.value([testRegularPost]),
            ),
          ],
          child: MaterialApp(
            onGenerateRoute: (settings) {
              if (settings.name == '/news-detail') {
                navigatedPostId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (context) => Container(),
                );
              }
              return null;
            },
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.text('Regular Post'));
      await tester.pump();

      // Verify navigation to news detail with correct post ID
      expect(navigatedPostId, equals('post-1'));
    });
  });

  testWidgets('HomeScreen formats dates correctly', (WidgetTester tester) async {
    final fixedTime = DateTime(2024, 1, 1, 15, 0); // Fixed current time
    final thirtyMinutesAgo = fixedTime.subtract(const Duration(minutes: 30));
    final threeHoursAgo = fixedTime.subtract(const Duration(hours: 3));
    final yesterday = fixedTime.subtract(const Duration(days: 1));

    final posts = [
      testRegularPost.copyWith(date: thirtyMinutesAgo, id: 'recent-post'),
      testRegularPost.copyWith(
        id: 'hours-ago-post',
        date: threeHoursAgo,
        title: 'Hours Ago Post',
      ),
      testRegularPost.copyWith(
        id: 'yesterday-post',
        date: yesterday,
        title: 'Yesterday Post',
      ),
    ];

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith((ref) => Stream.value(posts)),
          ],
          child: MaterialApp(
            home: HomeScreen(
              getCurrentTime: () => fixedTime,
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify date formatting
      expect(find.text("Men's Team • 30m ago"), findsOneWidget); // Recent post
      expect(find.text("Men's Team • 3h ago"), findsOneWidget); // Hours ago post
      expect(find.text("Men's Team • Yesterday"), findsOneWidget); // Yesterday post
    });
  });

  testWidgets('HomeScreen handles post without image gracefully',
      (WidgetTester tester) async {
    final fixedTime = DateTime(2024, 1, 1, 15, 0);
    final thirtyMinutesAgo = fixedTime.subtract(const Duration(minutes: 30));
    final postWithoutImage = testRegularPost.copyWith(
      image: '',
      date: thirtyMinutesAgo,
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.value([postWithoutImage]),
            ),
          ],
          child: MaterialApp(
            home: HomeScreen(
              getCurrentTime: () => fixedTime,
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text("Men's Team • 30m ago"), findsOneWidget);
      expect(find.text('Regular Post'), findsOneWidget);
    });
  });
} 