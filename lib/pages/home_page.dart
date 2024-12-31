import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void openUserBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: 
          Column(
            children: [
              Text("Nome"),
              TextField(
                controller: nameController,
              ),
              Text("Email"),
              TextField(
                controller: emailController,
              ),
              Text("Senha"),
              TextField(
                controller: passwordController,
              ),
            ],
          ),
        actions: [
          ElevatedButton(onPressed: () {
            firestoreService.addUser(nameController.text, emailController.text, passwordController.text);

            nameController.clear();
            emailController.clear();
            passwordController.clear();
          },
          child: Text("Add"))
        ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Usuários"),),
      floatingActionButton: FloatingActionButton(
        onPressed: openUserBox,
        child: const Icon(Icons.add),
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List userList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = userList[index];
                String docID = document.id;

                Map<String, dynamic> data = 
                  document.data() as Map<String, dynamic>;
                
                String userName = data['name'];
                String userEmail = data['email'];

                return ListTile(
                  title: Text(userName),
                  subtitle: Text(userEmail),
                );
              } 
            );
          } else {
            return const Text("Sem Usuáarios...");
          }
        },
      ),
    );
  }
}