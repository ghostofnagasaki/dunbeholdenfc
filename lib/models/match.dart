import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final String id;
  final String competition;
  final String homeTeamId;
  final String awayTeamId;
  final DateTime timestamp;
  final String status;
  final String type;
  final bool isLive;
  final bool hasHighlights;
  final bool hasFullMatch;
  
  // Simplify score handling
  final String? homeScore;
  final String? awayScore;

  Match({
    required this.id,
    required this.competition,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.timestamp,
    required this.status,
    required this.type,
    this.isLive = false,
    this.hasHighlights = false,
    this.hasFullMatch = false,
    this.homeScore,
    this.awayScore,
  });

  factory Match.fromMap(String id, Map<String, dynamic> map) {
    // Helper function to parse timestamp
    DateTime parseTimestamp(dynamic timestamp) {
      if (timestamp is Timestamp) return timestamp.toDate();
      if (timestamp is String) return DateTime.parse(timestamp);
      return DateTime.now(); // fallback
    }

    // Score parsing function
    String? parseScore(dynamic score) {
      if (score == null) return null;
      return score.toString();
    }

    return Match(
      id: id,
      competition: map['competition'] ?? '',
      homeTeamId: map['homeTeamId'] ?? '',
      awayTeamId: map['awayTeamId'] ?? '',
      timestamp: parseTimestamp(map['timestamp']),
      status: map['status'] ?? '',
      type: map['type'] ?? 'fixture',
      isLive: map['isLive'] ?? false,
      hasHighlights: map['hasHighlights'] ?? false,
      hasFullMatch: map['hasFullMatch'] ?? false,
      homeScore: parseScore(map['homeScore']),
      awayScore: parseScore(map['awayScore']),
    );
  }

  String? get formattedHomeScore => homeScore;
  String? get formattedAwayScore => awayScore;
} 