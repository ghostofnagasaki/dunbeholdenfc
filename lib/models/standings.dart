import 'package:cloud_firestore/cloud_firestore.dart';

class TeamStats {
  final int drawn;
  final List<String> form;
  final int goalDifference;
  final int goalsAgainst;
  final int goalsFor;
  final int lost;
  final int played;
  final int points;
  final int position;
  final int won;

  TeamStats({
    required this.drawn,
    required this.form,
    required this.goalDifference,
    required this.goalsAgainst,
    required this.goalsFor,
    required this.lost,
    required this.played,
    required this.points,
    required this.position,
    required this.won,
  });

  factory TeamStats.fromMap(Map<String, dynamic> map) {
    return TeamStats(
      drawn: map['drawn'] ?? 0,
      form: List<String>.from(map['form'] ?? []),
      goalDifference: map['goalDifference'] ?? 0,
      goalsAgainst: map['goalsAgainst'] ?? 0,
      goalsFor: map['goalsFor'] ?? 0,
      lost: map['lost'] ?? 0,
      played: map['played'] ?? 0,
      points: map['points'] ?? 0,
      position: map['position'] ?? 0,
      won: map['won'] ?? 0,
    );
  }
}

class TeamStanding {
  final DateTime lastUpdated;
  final String season;
  final TeamStats stats;
  final String teamId;
  final String teamLogo;
  final String teamName;

  TeamStanding({
    required this.lastUpdated,
    required this.season,
    required this.stats,
    required this.teamId,
    required this.teamLogo,
    required this.teamName,
  });

  factory TeamStanding.fromMap(Map<String, dynamic> map) {
    DateTime parseTimestamp(dynamic timestamp) {
      if (timestamp is Timestamp) return timestamp.toDate();
      if (timestamp is String) return DateTime.parse(timestamp);
      return DateTime.now();
    }

    return TeamStanding(
      lastUpdated: parseTimestamp(map['lastUpdated']),
      season: map['season'] ?? '',
      stats: TeamStats.fromMap(map['stats'] ?? {}),
      teamId: map['teamId'] ?? '',
      teamLogo: map['teamLogo'] ?? '',
      teamName: map['teamName'] ?? '',
    );
  }
} 