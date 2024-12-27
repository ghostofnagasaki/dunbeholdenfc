import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final standingsStreamProvider = StreamProvider<List<QueryDocumentSnapshot<Map<String, dynamic>>>>((ref) {
  return FirebaseFirestore.instance
      .collection('standings')
      .orderBy('stats.position')
      .snapshots()
      .map((snapshot) => snapshot.docs);
}); 