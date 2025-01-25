import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/membership.dart';

class MembershipRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitMembershipForm(Membership membership) async {
    try {
      await _firestore.collection('memberships').add(membership.toMap());
    } catch (e) {
      throw Exception('Failed to submit membership form: $e');
    }
  }

  Future<bool> hasPendingApplication(String email) async {
    final snapshot = await _firestore
        .collection('memberships')
        .where('email', isEqualTo: email)
        .where('status', isEqualTo: 'pending')
        .get();
    
    return snapshot.docs.isNotEmpty;
  }
} 