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

  void openUserBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docID == null ? "Adicionar Usuário" : "Editar Usuário"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nome",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameController.clear();
              emailController.clear();
              passwordController.clear();
              Navigator.of(context).pop();
            },
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreService.addUser(
                  nameController.text,
                  emailController.text,
                  passwordController.text,
                );
              } else {
                firestoreService.updateUser(
                  docID,
                  nameController.text,
                  emailController.text,
                  passwordController.text,
                );
              }
              nameController.clear();
              emailController.clear();
              passwordController.clear();
              Navigator.of(context).pop();
            },
            child: Text(docID == null ? "Adicionar" : "Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários"),
        centerTitle: true,
      ),
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
              padding: EdgeInsets.all(8.0),
              itemCount: userList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = userList[index];
                String docID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                String userName = data['name'];
                String userEmail = data['email'];

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        userName[0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(userEmail),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openUserBox(docID: docID),
                          icon: Icon(Icons.edit, color: Colors.orange),
                        ),
                        IconButton(
                          onPressed: () => firestoreService.deleteUser(docID),
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "Nenhum usuário encontrado..",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }
}
