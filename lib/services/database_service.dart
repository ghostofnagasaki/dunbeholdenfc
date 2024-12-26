// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/user.dart';


// class DatabaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;


//   Future<void> createUser(AppUser user) async {
//     await _firestore.collection('users').doc(user.id).set(user.toMap());
//   }

//   Future<AppUser> getUser(String userId) async {
//     final doc = await _firestore.collection('users').doc(userId).get();
//     return AppUser.fromMap(doc.data()!);
//   }

//   Future<void> updateUserRole(String userId, String role) async {
//     await _firestore.collection('users').doc(userId).update({'role': role});
//   }



//   Future<void> toggleLike(String postId) async {
//     // Implement the like toggle logic here
//     // You may need to store the user's likes separately and update both the post and user data
//   }
// }