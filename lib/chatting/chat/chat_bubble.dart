import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatBubble extends StatelessWidget {

  const ChatBubble({super.key, required this.message, required this.isMe, required this.userName, required this.userImage});

  final String message;
  final String userName;
  final bool isMe;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
          Text(userName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          BubbleSpecialThree(
            text: message,
            color: isMe ? Color(0xFF1B97F3) : Colors.brown[100]!,
            tail: true,
            isSender: isMe,
            textStyle: TextStyle(
                color: isMe ? Colors.white : Colors.black, fontSize: 16),
          ),
        ],),
        CircleAvatar(
          backgroundImage: NetworkImage(userImage),
        ),
      ],
    );
  }
}

// Row(
// mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
// children: [Container(
// decoration: BoxDecoration(
// color: isMe ? Colors.blue : Colors.brown[100],
// // borderRadius: BorderRadius.circular(12),
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(12),
// topRight: Radius.circular(12),
// bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
// bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
// ),
// ),
// width: 150,
// padding: EdgeInsets.all(8),
// margin: EdgeInsets.all(8),
// // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
// // margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// child: Text(message,
// style: TextStyle(color: isMe ? Colors.white : Colors.black),
// ),
// )],
// );
