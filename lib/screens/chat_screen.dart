import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../chatting/chat/message.dart';
import '../chatting/chat/new_message.dart';


class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loginedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loginedUser = user;
        print(loginedUser!.email);
      }
    } catch(e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        actions: [
          IconButton(onPressed: (){
            _authentication.signOut();
            // Navigator.pop(context);
          }, icon: Icon(Icons.exit_to_app_sharp, color: Colors.blue,),),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            // Expanded(child: Messages()),
            // NewMesasge(),
            Expanded(child: Messages(chatId: widget.chatId)),
            NewMessage(chatId: widget.chatId),
          ],
        ),
      ),
    );
  }
}
