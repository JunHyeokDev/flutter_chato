import 'package:chato/screens/skeleton_loader.dart';
import 'package:chato/screens/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'friend_list.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<Map<String, dynamic>> friendListData = [];
  Map<String, dynamic> me = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      final QuerySnapshot<
          Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('user').get();
      final user = FirebaseAuth.instance.currentUser!;

      // 모든 문서를 가져오려면 querySnapshot.docs를 사용합니다.
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot
          .docs) {
        Map<String, dynamic> userData = doc.data();
        userData['id'] = doc.id;

        if (user.uid != doc.id) {
          setState(() {
            friendListData.add(userData);
          });
        } else {
          setState(() {
            me = userData;
          });
        }
      }
    }
    catch (e) {
      print(e);
    }
    finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: isLoading ? SkeletonLoader() : ListView(
        children: [
          if (me != null)
          Container(
            alignment: Alignment.bottomLeft,
            child: UserProfile(me : me),
          ),
          Divider(thickness: 1, endIndent: 15, indent: 15, color: Colors.grey),
          FriendList(friendListData: friendListData),
        ],
      ),
    );
  }
}
