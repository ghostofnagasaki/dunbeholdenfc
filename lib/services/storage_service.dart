// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// class StorageService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<String> uploadFile(File file, String path) async {
//     final ref = _storage.ref().child(path);
//     final uploadTask = ref.putFile(file);
//     final snapshot = await uploadTask.whenComplete(() {});
//     return await snapshot.ref.getDownloadURL();
//   }
//   Future<String> uploadContent(String localPath) async {
//     File file = File(localPath);
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference ref = _storage.ref().child('content/$fileName');
//     await ref.putFile(file);
//     return await ref.getDownloadURL();
//   }

//   Future<void> deleteFile(String path) async {
//     await _storage.ref().child(path).delete();
//   }
// }
