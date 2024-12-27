import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class PlayersRepository {
  final FirebaseFirestore _firestore;

  PlayersRepository({FirebaseFirestore? firestore}) 
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Player>> getPlayers() {
    return _firestore
        .collection('players')
        .where('isActive', isEqualTo: true)
        .orderBy('position')
        .orderBy('jerseyNumber')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Player.fromMap(doc.id, doc.data()))
            .toList());
  }
} 