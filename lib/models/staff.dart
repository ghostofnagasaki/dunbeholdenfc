import 'package:cloud_firestore/cloud_firestore.dart';

class StaffSocialMedia {
  final String instagram;
  final String linkedin;
  final String twitter;

  StaffSocialMedia({
    required this.instagram,
    required this.linkedin,
    required this.twitter,
  });

  factory StaffSocialMedia.fromMap(Map<String, dynamic> map) {
    return StaffSocialMedia(
      instagram: map['instagram'] ?? '',
      linkedin: map['linkedin'] ?? '',
      twitter: map['twitter'] ?? '',
    );
  }
}

class Staff {
  final String id;
  final String achievements;
  final String biography;
  final DateTime dateJoined;
  final String email;
  final String image;
  final bool isActive;
  final String name;
  final String nationality;
  final String phone;
  final String previousExperience;
  final String qualifications;
  final String role;
  final StaffSocialMedia socialMedia;
  final DateTime updatedAt;
  final String databaseLocation;

  Staff({
    required this.id,
    required this.achievements,
    required this.biography,
    required this.dateJoined,
    required this.email,
    required this.image,
    required this.isActive,
    required this.name,
    required this.nationality,
    required this.phone,
    required this.previousExperience,
    required this.qualifications,
    required this.role,
    required this.socialMedia,
    required this.updatedAt,
    required this.databaseLocation,
  });

  factory Staff.fromMap(String id, Map<String, dynamic> map) {
    return Staff(
      id: id,
      achievements: map['achievements'] ?? '',
      biography: map['biography'] ?? '',
      dateJoined: (map['dateJoined'] as Timestamp).toDate(),
      email: map['email'] ?? '',
      image: map['image'] ?? '',
      isActive: map['isActive'] ?? false,
      name: map['name'] ?? '',
      nationality: map['nationality'] ?? '',
      phone: map['phone'] ?? '',
      previousExperience: map['previousExperience'] ?? '',
      qualifications: map['qualifications'] ?? '',
      role: map['role'] ?? '',
      socialMedia: StaffSocialMedia.fromMap(map['socialMedia'] ?? {}),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      databaseLocation: map['databaseLocation'] ?? '',
    );
  }
} 