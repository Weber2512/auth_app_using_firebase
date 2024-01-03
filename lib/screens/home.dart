import 'package:auth_app/widgets/chats_messages.dart';
import 'package:auth_app/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body:const Column(children: [
        Expanded(child: ChatsMessages()),
        NewMessages(),
      ],)
    );
  }
}
