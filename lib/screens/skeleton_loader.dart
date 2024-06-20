import 'package:flutter/material.dart';

class SkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // 예시로 5개의 아이템을 보여줍니다.
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(), // 예시로 간단한 아바타를 보여줍니다.
        title: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: 10.0,
          color: Colors.grey[300], // 스켈레톤 뷰의 색상
        ),
      ),
    );
  }
}