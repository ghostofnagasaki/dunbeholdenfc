import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:dunbeholden/screens/shop_screen.dart';

class MockUrlLauncher extends UrlLauncherPlatform {
  String? lastLaunchedUrl;

  @override
  Future<bool> launchUrl(String url, LaunchOptions? options) async {
    lastLaunchedUrl = url;
    return true;
  }

  @override
  Future<bool> canLaunch(String url) async {
    return true;
  }

  @override
  LinkDelegate? get linkDelegate => throw UnimplementedError();
}

void main() {
  late MockUrlLauncher mockUrlLauncher;

  setUp(() {
    mockUrlLauncher = MockUrlLauncher();
    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  const admiralUrl = 'https://admiral-sports.com/shop/usa_en/jersey-short-sleeve-custom-sublimated-1?xid=131071';

  Future<void> pumpShopScreen(WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1440, 2560);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    
    await tester.pumpWidget(
      const MaterialApp(home: ShopScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('ShopScreen displays all required UI elements', (tester) async {
    await pumpShopScreen(tester);

    expect(find.text('Club Shop'), findsOneWidget);
    expect(find.text('New Collection'), findsOneWidget);
    expect(find.text('Shop Now'), findsOneWidget);
    expect(find.text('Shop by Category'), findsOneWidget);
    
    // Scroll to ensure all elements are visible
    await tester.dragFrom(
      tester.getCenter(find.byType(SingleChildScrollView)), 
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kits'), findsOneWidget);
    expect(find.text('Training'), findsOneWidget);
    expect(find.text('Fashion'), findsOneWidget);
    expect(find.text('Accessories'), findsOneWidget);
    expect(find.text('Visit Official Store'), findsOneWidget);
  });

  testWidgets('URL launching tests', (tester) async {
    await pumpShopScreen(tester);

    // Test Shop Now button
    await tester.tap(find.text('Shop Now'));
    await tester.pumpAndSettle();
    expect(mockUrlLauncher.lastLaunchedUrl, equals(admiralUrl));

    // Test Kits category
    await tester.dragFrom(
      tester.getCenter(find.byType(SingleChildScrollView)), 
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Kits'));
    await tester.pumpAndSettle();
    expect(mockUrlLauncher.lastLaunchedUrl, equals(admiralUrl));

    // Test Visit Official Store button
    await tester.dragFrom(
      tester.getCenter(find.byType(SingleChildScrollView)), 
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Visit Official Store'));
    await tester.pumpAndSettle();
    expect(mockUrlLauncher.lastLaunchedUrl, equals(admiralUrl));
  });

  testWidgets('Shop banner image is displayed correctly', (tester) async {
    await pumpShopScreen(tester);

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final Image image = tester.widget(imageFinder);
    expect(image.fit, equals(BoxFit.cover));
    expect((image.image as AssetImage).assetName, equals('assets/images/shop_banner.jpg'));
  });

  testWidgets('Category tiles have correct styling', (tester) async {
    await pumpShopScreen(tester);

    final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
    for (final tile in listTiles) {
      expect(tile.contentPadding, equals(const EdgeInsets.all(16)));
      expect(tile.leading, isA<Icon>());
      expect(tile.trailing, isA<Icon>());
    }

    final cards = tester.widgetList<Card>(find.byType(Card));
    for (final card in cards) {
      expect(card.margin, equals(const EdgeInsets.only(bottom: 12)));
    }
  });
} 