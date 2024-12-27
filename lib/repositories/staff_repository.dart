import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/staff.dart';

class StaffRepository {
  final FirebaseFirestore _firestore;

  StaffRepository({FirebaseFirestore? firestore}) 
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Staff>> getStaff() {
    return _firestore
        .collection('staff')
        .where('isActive', isEqualTo: true)
        .orderBy('role')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Staff.fromMap(doc.id, doc.data()))
            .toList());
  }
} 