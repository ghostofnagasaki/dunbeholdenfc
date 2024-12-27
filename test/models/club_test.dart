import 'package:dunbeholden/models/club.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('Club Model', () {
    test('should create Club instance from map', () {
      final map = {
        'name': 'Test Club',
        'shortName': 'TST',
        'logoUrl': 'https://example.com/logo.png',
      };

      final club = Club.fromMap('club_id', map);

      expect(club.id, 'club_id');
      expect(club.name, 'Test Club');
      expect(club.shortName, 'TST');
      expect(club.logoUrl, 'https://example.com/logo.png');
    });

    test('should handle null values in map', () {
      final club = Club.fromMap('club_id', {});

      expect(club.id, 'club_id');
      expect(club.name, '');
      expect(club.shortName, '');
      expect(club.logoUrl, '');
    });
  });
} 