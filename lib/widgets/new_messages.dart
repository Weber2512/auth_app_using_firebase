import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {

  var _messagecontroller = TextEditingController();

  @override
  void dispose() {
    _messagecontroller.dispose();
    super.dispose();
  }

  void _submitMessages() async {
    var _enteredmessage = _messagecontroller.text;
    if(_enteredmessage == null || _enteredmessage.trim().isEmpty){
      return;
    }
    FocusScope.of(context).unfocus();
    _messagecontroller.clear();

    final userid = FirebaseAuth.instance.currentUser!;

    final userData =await FirebaseFirestore.instance.collection('users').doc(userid.uid).get();

    await FirebaseFirestore.instance.collection('messages').add({
      'text': _enteredmessage,
      'time': Timestamp.now(),
      'id': userid.uid,
      'username' : userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 14, right: 1),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messagecontroller,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              decoration:const  InputDecoration(labelText: 'Type the message...'),
            ),
          ),
          IconButton(onPressed: _submitMessages, icon: Icon(Icons.send)),
        ],
      ),
    );
  }
}
