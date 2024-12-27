import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunbeholden/models/match.dart';

void main() {
  group('Match Model', () {
    test('should create Match instance from map', () {
      final timestamp = Timestamp.fromDate(DateTime(2024, 3, 20, 15, 30));
      final map = {
        'competition': 'Premier League',
        'homeTeamId': 'team1',
        'awayTeamId': 'team2',
        'timestamp': timestamp,
        'status': 'Scheduled',
        'type': 'fixture',
        'isLive': false,
        'hasHighlights': false,
        'hasFullMatch': false,
        'homeScore': '2',
        'awayScore': '1',
      };

      final match = Match.fromMap('match_id', map);

      expect(match.id, 'match_id');
      expect(match.competition, 'Premier League');
      expect(match.homeTeamId, 'team1');
      expect(match.awayTeamId, 'team2');
      expect(match.timestamp, timestamp.toDate());
      expect(match.status, 'Scheduled');
      expect(match.type, 'fixture');
      expect(match.isLive, false);
      expect(match.hasHighlights, false);
      expect(match.hasFullMatch, false);
      expect(match.homeScore, '2');
      expect(match.awayScore, '1');
    });

    test('should handle null values in map', () {
      final timestamp = Timestamp.fromDate(DateTime(2024, 3, 20, 15, 30));
      final map = {
        'timestamp': timestamp,
      };

      final match = Match.fromMap('match_id', map);

      expect(match.id, 'match_id');
      expect(match.competition, '');
      expect(match.homeTeamId, '');
      expect(match.awayTeamId, '');
      expect(match.status, '');
      expect(match.type, 'fixture');
      expect(match.isLive, false);
      expect(match.hasHighlights, false);
      expect(match.hasFullMatch, false);
      expect(match.homeScore, null);
      expect(match.awayScore, null);
    });

    test('formatted scores should return null when scores are null', () {
      final timestamp = Timestamp.fromDate(DateTime(2024, 3, 20, 15, 30));
      final match = Match.fromMap('match_id', {'timestamp': timestamp});

      expect(match.formattedHomeScore, null);
      expect(match.formattedAwayScore, null);
    });
  });
} 