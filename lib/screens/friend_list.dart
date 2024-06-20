import 'package:chato/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FriendList extends StatelessWidget {

  FriendList({super.key, required this.friendListData});
  final List<Map<String, dynamic>> friendListData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: friendListData.length,
      itemBuilder: (context, index) {
        var friend = friendListData[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(friend['picked_image']),
          ),
          title: Text(friend['userName']),
          subtitle: Text(friend['status']),
          onLongPress: () => _tryChatWithFriend(context,friend),
        );
      },
    );
  }
}

void _tryChatWithFriend(BuildContext context, Map<String, dynamic> friend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Start Chat'),
          content: Text('Do you want to start a chat with ${friend['userName']}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                final cur = FirebaseAuth.instance.currentUser;
                if (cur == null) return;

                final curUserId = cur.uid;
                final friendId = friend['id'];

                String chatId = await _getOrCreateChatId(curUserId, friendId);

                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return ChatScreen(chatId: chatId);
                }));
              },
              child: Text('Start Chat'),
            ),
          ],
        );
      },
    );
}


Future<String> _getOrCreateChatId(String currentUserId, String friendId) async {
  final chatCollection = FirebaseFirestore.instance.collection('chats');

  // 두 사용자 모두 참여하는 채팅방 검색
  final chatQuery = await chatCollection
      .where('participants', arrayContains: currentUserId)
      .get();

  for (var chatDoc in chatQuery.docs) {
    if ((chatDoc['participants'] as List).contains(friendId)) {
      return chatDoc.id;
    }
  }

  // 채팅방이 없으면 새로 생성
  final newChatDoc = await chatCollection.add({
    'participants': [currentUserId, friendId],
    'createdAt': Timestamp.now(),
  });

  return newChatDoc.id;
}