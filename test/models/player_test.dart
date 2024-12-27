import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunbeholden/models/player.dart';

void main() {
  group('Player Model', () {
    test('should create Player instance from map', () {
      final timestamp = Timestamp.fromDate(DateTime(2024, 3, 20));
      final map = {
        'actionImage': 'action.jpg',
        'appearances': 10,
        'assists': 5,
        'biography': 'Player bio',
        'dateOfBirth': timestamp,
        'goals': 8,
        'height': '180',
        'isActive': true,
        'jerseyNumber': '10',
        'name': 'John Doe',
        'nationality': 'Jamaican',
        'position': 'Forward',
        'previousClubs': 'Previous clubs',
        'profileImage': 'profile.jpg',
        'updatedAt': timestamp,
        'weight': '75',
        'databaseLocation': 'nam5',
      };

      final player = Player.fromMap('player_id', map);

      expect(player.id, 'player_id');
      expect(player.actionImage, 'action.jpg');
      expect(player.appearances, 10);
      expect(player.assists, 5);
      expect(player.biography, 'Player bio');
      expect(player.dateOfBirth, timestamp.toDate());
      expect(player.goals, 8);
      expect(player.height, '180');
      expect(player.isActive, true);
      expect(player.jerseyNumber, '10');
      expect(player.name, 'John Doe');
      expect(player.nationality, 'Jamaican');
      expect(player.position, 'Forward');
      expect(player.previousClubs, 'Previous clubs');
      expect(player.profileImage, 'profile.jpg');
      expect(player.updatedAt, timestamp.toDate());
      expect(player.weight, '75');
      expect(player.databaseLocation, 'nam5');
    });

    test('should handle null values in map', () {
      final timestamp = Timestamp.fromDate(DateTime(2024, 3, 20));
      final map = {
        'dateOfBirth': timestamp,
        'updatedAt': timestamp,
      };

      final player = Player.fromMap('player_id', map);

      expect(player.id, 'player_id');
      expect(player.actionImage, '');
      expect(player.appearances, 0);
      expect(player.assists, 0);
      expect(player.biography, '');
      expect(player.goals, 0);
      expect(player.height, '');
      expect(player.isActive, false);
      expect(player.jerseyNumber, '');
      expect(player.name, '');
      expect(player.nationality, '');
      expect(player.position, '');
      expect(player.previousClubs, '');
      expect(player.profileImage, '');
      expect(player.weight, '');
      expect(player.databaseLocation, '');
    });
  });
} 