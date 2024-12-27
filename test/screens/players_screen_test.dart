import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dunbeholden/screens/players_screen.dart';
import 'package:dunbeholden/models/player.dart';

void main() {
  final testPlayer = Player(
    id: 'test_id',
    name: 'Test Player',
    jerseyNumber: '10',
    position: 'Forward',
    profileImage: 'test_image.jpg',
    nationality: 'Jamaica',
    dateOfBirth: DateTime(1995, 6, 15),
    height: '180cm',
    weight: '75kg',
    preferredFoot: 'Right',
    appearances: 20,
    goals: 10,
    assists: 5,
    cleanSheets: 0,
    isActive: true,
    biography: 'Test bio',
    previousClubs: 'Previous clubs',
    updatedAt: DateTime.now(),
  );

  testWidgets('PlayerCard displays player information correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlayerCard(player: testPlayer),
      ),
    );

    expect(find.text('Test Player'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('FORWARD'), findsOneWidget);
  });

  // Add more tests as needed
} 