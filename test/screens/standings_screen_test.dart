import 'package:dunbeholden/providers/standings_provider.dart';
import 'package:dunbeholden/screens/standings_screen.dart';
import 'package:dunbeholden/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import '../helpers/mocks.dart';

void main() {
  group('StandingsScreen', () {
    testWidgets('should display loading state initially',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              standingsStreamProvider.overrideWith((_) => const Stream.empty()),
            ],
            child: const MaterialApp(
              home: StandingsScreen(),
            ),
          ),
        );

        await tester.pump();
        expect(find.byType(LoadingView), findsOneWidget);
      });
    });

    testWidgets('should display standings when data is available',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final mockStandings = [
          MockStandingDocumentSnapshot(
            teamName: 'Test Team',
            teamLogo: 'test_logo.png',
            position: 1,
            points: 30,
            played: 15,
            won: 9,
            drawn: 3,
            lost: 3,
            goalDifference: 10,
          ),
        ];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              standingsStreamProvider
                  .overrideWith((_) => Stream.value(mockStandings)),
            ],
            child: const MaterialApp(
              home: StandingsScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('STANDINGS'), findsOneWidget);
        expect(find.text('Test Team'), findsOneWidget);
        expect(find.text('30'), findsOneWidget); // points
        expect(find.text('15'), findsOneWidget); // played
        expect(find.text('9'), findsOneWidget); // won
        expect(find.text('3'), findsWidgets); // drawn and lost
        expect(find.text('+10'), findsOneWidget); // goal difference
      });
    });
  });
} 