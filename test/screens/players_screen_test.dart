import 'package:dunbeholden/providers/players_provider.dart';
import 'package:dunbeholden/screens/players_screen.dart';
import 'package:dunbeholden/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:dunbeholden/models/player.dart';

void main() {
  group('PlayersScreen', () {
    testWidgets('should display loading state initially',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              playersStreamProvider.overrideWith(
                (_) => const Stream.empty(),
              ),
            ],
            child: const MaterialApp(
              home: PlayersScreen(),
            ),
          ),
        );

        await tester.pump();
        expect(find.byType(LoadingView), findsOneWidget);
      });
    });

    testWidgets('should display players grouped by position',
        (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        final players = [
          Player(
            id: 'player1',
            name: 'John Doe',
            position: 'Goalkeeper',
            jerseyNumber: '1',
            actionImage: '',
            appearances: 0,
            assists: 0,
            biography: '',
            dateOfBirth: DateTime.now(),
            goals: 0,
            height: '',
            isActive: true,
            nationality: '',
            previousClubs: '',
            profileImage: '',
            updatedAt: DateTime.now(),
            weight: '',
            databaseLocation: '',
          ),
        ];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              playersStreamProvider.overrideWith((_) => Stream.value(players)),
            ],
            child: const MaterialApp(
              home: PlayersScreen(),
            ),
          ),
        );

        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('GOALKEEPERS'), findsOneWidget);
        expect(find.text('JOHN DOE'), findsOneWidget);
      });
    });
  });
} 