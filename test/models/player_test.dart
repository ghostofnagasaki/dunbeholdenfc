import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dunbeholden/models/player.dart';

void main() {
  group('Player', () {
    test('fromMap creates a Player instance with correct data', () {
      final now = DateTime.now();
      final map = {
        'name': 'Test Player',
        'jerseyNumber': '10',
        'position': 'Forward',
        'profileImage': 'test_image.jpg',
        'nationality': 'Jamaica',
        'dateOfBirth': Timestamp.fromDate(now),
        'height': '180cm',
        'weight': '75kg',
        'preferredFoot': 'Right',
        'appearances': 20,
        'goals': 10,
        'assists': 5,
        'cleanSheets': 0,
        'isActive': true,
        'biography': 'Test bio',
        'previousClubs': 'Previous clubs',
        'updatedAt': Timestamp.fromDate(now),
      };

      final player = Player.fromMap('test_id', map);

      expect(player.id, 'test_id');
      expect(player.name, 'Test Player');
      expect(player.jerseyNumber, '10');
      expect(player.position, 'Forward');
      expect(player.profileImage, 'test_image.jpg');
      expect(player.nationality, 'Jamaica');
      expect(player.dateOfBirth, now);
      expect(player.height, '180cm');
      expect(player.weight, '75kg');
      expect(player.preferredFoot, 'Right');
      expect(player.appearances, 20);
      expect(player.goals, 10);
      expect(player.assists, 5);
      expect(player.cleanSheets, 0);
      expect(player.isActive, true);
      expect(player.biography, 'Test bio');
      expect(player.previousClubs, 'Previous clubs');
      expect(player.updatedAt, now);
    });

    test('fromMap handles missing data with defaults', () {
      final map = <String, dynamic>{};

      final player = Player.fromMap('test_id', map);

      expect(player.id, 'test_id');
      expect(player.name, '');
      expect(player.jerseyNumber, '');
      expect(player.position, '');
      expect(player.profileImage, '');
      expect(player.nationality, '');
      expect(player.dateOfBirth, null);
      expect(player.height, '');
      expect(player.weight, '');
      expect(player.preferredFoot, '');
      expect(player.appearances, 0);
      expect(player.goals, 0);
      expect(player.assists, 0);
      expect(player.cleanSheets, 0);
      expect(player.isActive, true);
      expect(player.biography, '');
      expect(player.previousClubs, '');
      expect(player.updatedAt, null);
    });

    test('formattedDateOfBirth returns correct format', () {
      final dateOfBirth = DateTime(1995, 6, 15);
      final player = Player(
        id: 'test_id',
        name: 'Test Player',
        jerseyNumber: '10',
        position: 'Forward',
        profileImage: 'test_image.jpg',
        nationality: 'Jamaica',
        dateOfBirth: dateOfBirth,
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

      expect(player.formattedDateOfBirth, '15/6/1995');
    });
  });
} 