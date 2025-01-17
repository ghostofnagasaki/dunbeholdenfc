import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/club.dart';

class ClubsRepository {
  final FirebaseFirestore _firestore;

  ClubsRepository({FirebaseFirestore? firestore}) 
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, Club>> getClubs() async {
    try {
      final snapshot = await _firestore
          .collection('clubs')
          .where('isActive', isEqualTo: true)
          .get();
          
      // debugPrint('Got ${snapshot.docs.length} clubs');
      
      Map<String, Club> clubs = {};
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          // debugPrint('Club data for ${doc.id}: $data');
          clubs[doc.id] = Club.fromMap(doc.id, data);
        } catch (e) {
          // debugPrint('Error parsing club ${doc.id}: $e\n$stack');
          rethrow;
        }
      }
      return clubs;
    } catch (e, stack) {
      debugPrint('Error getting clubs: $e\n$stack');
      rethrow;
    }
  }
} 