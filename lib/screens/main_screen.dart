import 'package:chato/screens/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'friends_screen.dart';
import 'chat_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  late String currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!.uid;

    _widgetOptions = <Widget>[
      FriendsScreen(),
      ChatListScreen(currentUserId: currentUser),
      SettingScreen(),
    ];
  }

  void fetchCurrentUserDocument() async {
    try {
      // 현재 인증된 사용자 가져오기
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Firestore에서 'users' 컬렉션에서 해당 사용자의 문서 가져오기
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('users') // 여기서 'users'는 사용자 정보를 저장하는 컬렉션 이름입니다.
            .doc(user.uid) // 사용자의 uid를 기반으로 문서를 가져옵니다.
            .get();

        if (snapshot.exists) {
          // 문서가 존재하는 경우, 데이터에 접근할 수 있습니다.
          Map<String, dynamic> userData = snapshot.data()!;
          print('User data: $userData');
        } else {
          print('Document does not exist');
        }
      } else {
        print('No user signed in');
      }
    } catch (e) {
      print('Error fetching user document: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}