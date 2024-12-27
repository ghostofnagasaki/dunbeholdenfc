import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String actionImage;
  final int appearances;
  final int assists;
  final String biography;
  final DateTime dateOfBirth;
  final int goals;
  final String height;
  final bool isActive;
  final String jerseyNumber;
  final String name;
  final String nationality;
  final String position;
  final String previousClubs;
  final String profileImage;
  final DateTime updatedAt;
  final String weight;
  final String databaseLocation;

  Player({
    required this.id,
    required this.actionImage,
    required this.appearances,
    required this.assists,
    required this.biography,
    required this.dateOfBirth,
    required this.goals,
    required this.height,
    required this.isActive,
    required this.jerseyNumber,
    required this.name,
    required this.nationality,
    required this.position,
    required this.previousClubs,
    required this.profileImage,
    required this.updatedAt,
    required this.weight,
    required this.databaseLocation,
  });

  factory Player.fromMap(String id, Map<String, dynamic> map) {
    return Player(
      id: id,
      actionImage: map['actionImage'] ?? '',
      appearances: map['appearances'] ?? 0,
      assists: map['assists'] ?? 0,
      biography: map['biography'] ?? '',
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      goals: map['goals'] ?? 0,
      height: map['height'] ?? '',
      isActive: map['isActive'] ?? false,
      jerseyNumber: map['jerseyNumber'] ?? '',
      name: map['name'] ?? '',
      nationality: map['nationality'] ?? '',
      position: map['position'] ?? '',
      previousClubs: map['previousClubs'] ?? '',
      profileImage: map['profileImage'] ?? '',
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      weight: map['weight'] ?? '',
      databaseLocation: map['databaseLocation'] ?? '',
    );
  }
} 