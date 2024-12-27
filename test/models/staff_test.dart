import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dunbeholden/models/staff.dart';

void main() {
  group('Staff Model', () {
    test('should create StaffSocialMedia instance from map', () {
      final map = {
        'instagram': 'insta_handle',
        'linkedin': 'linkedin_profile',
        'twitter': 'twitter_handle',
      };

      final socialMedia = StaffSocialMedia.fromMap(map);

      expect(socialMedia.instagram, 'insta_handle');
      expect(socialMedia.linkedin, 'linkedin_profile');
      expect(socialMedia.twitter, 'twitter_handle');
    });

    test('should create Staff instance from map', () {
      final timestamp = Timestamp.fromDate(DateTime(2024, 3, 20));
      final map = {
        'achievements': 'Many trophies',
        'biography': 'Staff bio',
        'dateJoined': timestamp,
        'email': 'staff@example.com',
        'image': 'staff.jpg',
        'isActive': true,
        'name': 'John Smith',
        'nationality': 'Jamaican',
        'phone': '1234567890',
        'previousExperience': 'Previous clubs',
        'qualifications': 'UEFA Pro License',
        'role': 'Coach',
        'socialMedia': {
          'instagram': 'insta_handle',
          'linkedin': 'linkedin_profile',
          'twitter': 'twitter_handle',
        },
        'updatedAt': timestamp,
        'databaseLocation': 'nam5',
      };

      final staff = Staff.fromMap('staff_id', map);

      expect(staff.id, 'staff_id');
      expect(staff.achievements, 'Many trophies');
      expect(staff.biography, 'Staff bio');
      expect(staff.dateJoined, timestamp.toDate());
      expect(staff.email, 'staff@example.com');
      expect(staff.image, 'staff.jpg');
      expect(staff.isActive, true);
      expect(staff.name, 'John Smith');
      expect(staff.nationality, 'Jamaican');
      expect(staff.phone, '1234567890');
      expect(staff.previousExperience, 'Previous clubs');
      expect(staff.qualifications, 'UEFA Pro License');
      expect(staff.role, 'Coach');
      expect(staff.socialMedia.instagram, 'insta_handle');
      expect(staff.updatedAt, timestamp.toDate());
      expect(staff.databaseLocation, 'nam5');
    });
  });
} 