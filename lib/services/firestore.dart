import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  //CREATE
  Future<void> addUser(String name, String email, String password) {
    return users.add({
      'name': name,
      'email': email,
      'password': password,
      'timestamp': Timestamp.now(),
    });
  }

  //READ
  Stream<QuerySnapshot> getUsersStream() {
    final usersStream =
      users.orderBy('timestamp', descending: true).snapshots();

    return usersStream;
  }

  //UPDATE
  Future<void> updateUser(String docID, String newName, String newEmail, String newPassword) {
    return users.doc(docID).update({
      'name': newName,
      'email': newEmail,
      'password': newPassword,
      'timestamp': Timestamp.now(),
    });
  }

  //DELETE
  Future<void> deleteUser(String docID) {
    return users.doc(docID).delete();
  }

}