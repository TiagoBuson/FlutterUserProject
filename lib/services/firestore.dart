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
  
}