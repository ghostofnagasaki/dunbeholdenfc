import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Membership {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String address;
  final DateTime createdAt;
  final String status; // pending, approved, rejected
  final String membershipType; // standard, premium, etc.
  final String membershipCode; // New field

  Membership({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.address,
    required this.createdAt,
    this.status = 'pending',
    required this.membershipType,
    required this.membershipCode,
  });

  // Generate random 6-digit alphanumeric code
  static String generateMembershipCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Map<String, dynamic> toMap() {
    // Add debug print to verify data structure
    final map = {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'address': address,
      'createdAt': Timestamp.fromDate(DateTime.now()), // Use current time
      'status': 'pending',  // Ensure status is always pending
      'membershipType': membershipType,
      'membershipCode': membershipCode,
    };
    print('Membership data being sent: $map'); // Debug print
    return map;
  }
} 