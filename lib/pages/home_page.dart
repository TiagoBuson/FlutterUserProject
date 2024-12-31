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
    );
  }
}