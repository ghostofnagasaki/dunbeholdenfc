import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/match.dart';

class MatchesRepository {
  final FirebaseFirestore _firestore;

  MatchesRepository({FirebaseFirestore? firestore}) 
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Match>> getMatches() {
    try {
      return _firestore
          .collection('matches')
          .orderBy('timestamp')
          .snapshots()
          .map((snapshot) {
            try {
              return snapshot.docs.map((doc) {
                try {
                  final data = doc.data();
                  debugPrint('Match data for ${doc.id}: $data');
                  return Match.fromMap(doc.id, data);
                } catch (e, stack) {
                  debugPrint('Error parsing match ${doc.id}: $e\n$stack');
                  rethrow;
                }
              }).toList();
            } catch (e, stack) {
              debugPrint('Error mapping matches: $e\n$stack');
              rethrow;
            }
          });
    } catch (e, stack) {
      debugPrint('Error getting matches stream: $e\n$stack');
      rethrow;
    }
  }
} 