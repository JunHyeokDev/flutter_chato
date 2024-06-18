import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMesasge extends StatefulWidget {
  const NewMesasge({super.key});

  @override
  State<NewMesasge> createState() => _NewMesasgeState();
}

class _NewMesasgeState extends State<NewMesasge> {
  final _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  var _userEnterMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final userData = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': user.uid,
      'userName' : userData.data()!['userName'],
      'userImage' : userData.data()!['picked_image'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 8, 0, 15),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: _userEnterMessage.trim().isEmpty ? Colors.black12 : Colors.lightBlueAccent,
            ),
            child: IconButton(
              onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
              icon: Icon(Icons.send),
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
