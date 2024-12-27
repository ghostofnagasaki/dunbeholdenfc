import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String name;
  final String jerseyNumber;
  final String position;
  final String profileImage;
  final String nationality;
  final DateTime? dateOfBirth;
  final String height;
  final String weight;
  final String preferredFoot;
  final int appearances;
  final int goals;
  final int assists;
  final int cleanSheets;
  final bool isActive;
  final String biography;
  final String previousClubs;
  final DateTime? updatedAt;

  Player({
    required this.id,
    required this.name,
    required this.jerseyNumber,
    required this.position,
    required this.profileImage,
    required this.nationality,
    this.dateOfBirth,
    required this.height,
    required this.weight,
    required this.preferredFoot,
    required this.appearances,
    required this.goals,
    required this.assists,
    required this.cleanSheets,
    required this.isActive,
    required this.biography,
    required this.previousClubs,
    this.updatedAt,
  });

  factory Player.fromMap(String id, Map<String, dynamic> map) {
    return Player(
      id: id,
      name: map['name'] ?? '',
      jerseyNumber: map['jerseyNumber'] ?? '',
      position: map['position'] ?? '',
      profileImage: map['profileImage'] ?? '',
      nationality: map['nationality'] ?? '',
      dateOfBirth: map['dateOfBirth'] != null 
          ? (map['dateOfBirth'] as Timestamp).toDate() 
          : null,
      height: map['height'] ?? '',
      weight: map['weight'] ?? '',
      preferredFoot: map['preferredFoot'] ?? '',
      appearances: map['appearances'] ?? 0,
      goals: map['goals'] ?? 0,
      assists: map['assists'] ?? 0,
      cleanSheets: map['cleanSheets'] ?? 0,
      isActive: map['isActive'] ?? true,
      biography: map['biography'] ?? '',
      previousClubs: map['previousClubs'] ?? '',
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  String get formattedDateOfBirth {
    if (dateOfBirth == null) return 'N/A';
    return '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}';
  }
} 