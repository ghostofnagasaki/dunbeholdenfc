// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> deleteUserData() async {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         // Delete user data from Firestore
//         await _firestore.collection('users').doc(user.uid).delete();
//         await _firestore.collection('predictions').where('userId', isEqualTo: user.uid).get().then((snapshot) {
//           for (DocumentSnapshot doc in snapshot.docs) {
//             doc.reference.delete();
//           }
//         });
//         // Add any other collections that need to be cleaned up

//         // Delete the user authentication account
//         await user.delete();
        
//         // Sign out
//         await _auth.signOut();
//       }
//     } catch (e) {
//       rethrow; // This will allow us to handle the error in the UI
//     }
//   }
// } 