import 'package:dunbeholden/providers/clubs_provider.dart';
import 'package:dunbeholden/providers/matches_provider.dart';
import 'package:dunbeholden/providers/standings_provider.dart';
import 'package:dunbeholden/screens/matches_screen.dart';
import 'package:dunbeholden/screens/standings_screen.dart';
import 'package:dunbeholden/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:dunbeholden/models/match.dart';
import 'package:dunbeholden/models/club.dart';



void main() {
  group('MatchesScreen', () {
    testWidgets('should display loading state initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MatchesScreen(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(LoadingView), findsOneWidget);
    });

    testWidgets('should display matches when data is available',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final matches = [
          Match(
            id: 'match1',
            competition: 'Premier League',
            homeTeamId: 'team1',
            awayTeamId: 'team2',
            timestamp: DateTime(2024, 3, 20, 15, 30),
            status: 'Scheduled',
            type: 'fixture',
            isLive: false,
            hasHighlights: false,
            hasFullMatch: false,
            homeScore: null,
            awayScore: null,
          ),
        ];

        final clubs = {
          'team1': Club(
            id: 'team1',
            name: 'Home Team',
            shortName: 'HOME',
            logoUrl: 'home_logo.png',
            isActive: true,
          ),
          'team2': Club(
            id: 'team2',
            name: 'Away Team',
            shortName: 'AWAY',
            logoUrl: 'away_logo.png',
            isActive: true,
          ),
        };

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              matchesStreamProvider.overrideWith((_) => Stream.value(matches)),
              clubsProvider.overrideWith((_) => Future.value(clubs)),
            ],
            child: const MaterialApp(
              home: MatchesScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('MATCHES'), findsOneWidget);
        expect(find.text('Premier League'), findsOneWidget);
        expect(find.text('Home Team'), findsOneWidget);
        expect(find.text('Away Team'), findsOneWidget);
      });
    });

    testWidgets('should switch tabs correctly', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              matchesStreamProvider.overrideWith((_) => Stream.value([])),
              clubsProvider.overrideWith((_) => Future.value({})),
              standingsStreamProvider.overrideWith((_) => Stream.value([])),
            ],
            child: const MaterialApp(
              home: MatchesScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        await tester.tap(find.text('Results'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('No Results Available'), findsOneWidget);

        await tester.tap(find.text('Standings'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(
          find.byType(StandingsScreen),
          findsOneWidget,
          reason: 'StandingsScreen should be visible',
        );
      });
    });
  });
} 