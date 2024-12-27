import 'package:flutter_test/flutter_test.dart';
import 'package:dunbeholden/models/standings.dart';

void main() {
  group('TeamStats', () {
    test('should create TeamStats instance from map', () {
      final map = {
        'drawn': 5,
        'form': ['W', 'D', 'L'],
        'goalDifference': 10,
        'goalsAgainst': 15,
        'goalsFor': 25,
        'lost': 3,
        'played': 20,
        'points': 40,
        'position': 2,
        'won': 12,
      };

      final stats = TeamStats.fromMap(map);

      expect(stats.drawn, 5);
      expect(stats.form, ['W', 'D', 'L']);
      expect(stats.goalDifference, 10);
      expect(stats.goalsAgainst, 15);
      expect(stats.goalsFor, 25);
      expect(stats.lost, 3);
      expect(stats.played, 20);
      expect(stats.points, 40);
      expect(stats.position, 2);
      expect(stats.won, 12);
    });

    test('should handle null values in map', () {
      final stats = TeamStats.fromMap({});

      expect(stats.drawn, 0);
      expect(stats.form, isEmpty);
      expect(stats.goalDifference, 0);
      expect(stats.goalsAgainst, 0);
      expect(stats.goalsFor, 0);
      expect(stats.lost, 0);
      expect(stats.played, 0);
      expect(stats.points, 0);
      expect(stats.position, 0);
      expect(stats.won, 0);
    });
  });
} 