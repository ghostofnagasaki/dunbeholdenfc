import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/standings.dart';

class StandingsRepository {
  final FirebaseFirestore _firestore;

  StandingsRepository({FirebaseFirestore? firestore}) 
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<TeamStanding>> getStandings() {
    debugPrint('Getting standings from Firestore...');
    try {
      return _firestore
          .collection('standings')
          .orderBy('stats.position')
          .snapshots()
          .map((snapshot) {
            // debugPrint('Received ${snapshot.docs.length} standings documents');
            return snapshot.docs.map((doc) {
              final data = doc.data();
              // debugPrint('Processing standing document: ${doc.id}');
              return TeamStanding.fromMap(data);
            }).toList();
          });
    } catch (e) {
      // debugPrint('Error getting standings: $e\n$stack');
      rethrow;
    }
  }

} 