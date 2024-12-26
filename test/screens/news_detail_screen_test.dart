import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:dunbeholden/screens/news_detail_screen.dart';
import 'package:dunbeholden/providers/post_provider.dart';
import 'package:intl/intl.dart';

void main() {
  final testPost = Post(
    id: 'test-post-1',
    title: 'Test Post Title',
    content: '<p>Test content with <b>HTML</b> tags</p>',
    summary: 'Test Summary',
    category: 'News',
    date: DateTime(2024, 1, 1, 12, 30),
    image: 'https://example.com/test.jpg',
    author: 'John Doe',
    featured: true,
    seoDescription: 'Test SEO Description',
    slug: 'test-post',
    status: 'published',
    tags: ['test', 'news'],
  );

  testWidgets('NewsDetailScreen shows loading state', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith((ref) => Stream.value([])),
          ],
          child: const MaterialApp(
            home: NewsDetailScreen(postId: 'test-post-1'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('NewsDetailScreen shows error state when post not found',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.value([testPost]),
            ),
          ],
          child: const MaterialApp(
            home: NewsDetailScreen(postId: 'non-existent-post'),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Post not found'), findsOneWidget);
    });
  });

  testWidgets('NewsDetailScreen displays post content correctly',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.value([testPost]),
            ),
          ],
          child: const MaterialApp(
            home: NewsDetailScreen(postId: 'test-post-1'),
          ),
        ),
      );

      await tester.pump();

      // Verify title is displayed
      expect(find.text('Test Post Title'), findsOneWidget);

      // Verify author information is displayed
      expect(find.text('by John Doe'), findsOneWidget);

      // Verify date is formatted correctly
      final expectedDate = DateFormat('EEE dd MMM yyyy, HH:mm')
          .format(DateTime(2024, 1, 1, 12, 30));
      expect(find.text(expectedDate), findsOneWidget);

      // Verify category tag is displayed
      expect(find.text("MEN'S TEAM"), findsOneWidget);

      // Verify HTML content is parsed correctly
      expect(find.text('Test content with HTML tags'), findsOneWidget);
    });
  });

  testWidgets('NewsDetailScreen handles HTML content parsing',
      (WidgetTester tester) async {
    final postWithComplexHtml = testPost.copyWith(
      content: '''<p>First paragraph</p><p>Second paragraph with <b>bold</b> text</p><p>Special characters: &quot;quoted&quot; &amp; &apos;text&apos;</p>''',
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.value([postWithComplexHtml]),
            ),
          ],
          child: const MaterialApp(
            home: NewsDetailScreen(postId: 'test-post-1'),
          ),
        ),
      );

      await tester.pump();

      // Verify HTML is properly parsed into a single text block
      expect(
        find.text('First paragraphSecond paragraph with bold textSpecial characters: "quoted" & \'text\''),
        findsOneWidget,
      );
    });
  });

  testWidgets('NewsDetailScreen handles missing image gracefully',
      (WidgetTester tester) async {
    final postWithoutImage = testPost.copyWith(image: '');

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.value([postWithoutImage]),
            ),
          ],
          child: const MaterialApp(
            home: NewsDetailScreen(postId: 'test-post-1'),
          ),
        ),
      );

      await tester.pump();

      // Verify the screen displays without errors when image is missing
      expect(find.text('Test Post Title'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });
  });

  testWidgets('NewsDetailScreen back button works correctly',
      (WidgetTester tester) async {
    bool navigationPopped = false;

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.value([testPost]),
            ),
          ],
          child: MaterialApp(
            home: const NewsDetailScreen(postId: 'test-post-1'),
            navigatorObservers: [
              MockNavigatorObserver(onPop: () => navigationPopped = true),
            ],
          ),
        ),
      );

      await tester.pump();

      // Tap the back button
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pump();

      // Verify navigation
      expect(navigationPopped, true);
    });
  });

  testWidgets('NewsDetailScreen share button is present',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsStreamProvider.overrideWith(
              (ref) => Stream.value([testPost]),
            ),
          ],
          child: const MaterialApp(
            home: NewsDetailScreen(postId: 'test-post-1'),
          ),
        ),
      );

      await tester.pump();

      // Verify share button is present
      expect(find.byIcon(Icons.share), findsOneWidget);
    });
  });
}

class MockNavigatorObserver extends NavigatorObserver {
  final VoidCallback onPop;

  MockNavigatorObserver({required this.onPop});

  @override
  void didPop(Route route, Route? previousRoute) {
    onPop();
  }
} 