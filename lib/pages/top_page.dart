import 'package:flutter/material.dart';
import 'package:flutter_udemy_chatapp02/model/user.dart';
import 'package:flutter_udemy_chatapp02/pages/setting_profile_page.dart';
import 'package:flutter_udemy_chatapp02/pages/talk_room_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<TopPage> {
  List<User> userList = [
    User(
        name: '田中',
        uid: 'abc',
        imagePath:
            'https://assets.st-note.com/production/uploads/images/95747620/rectangle_large_type_2_657b16e7308ea52d7f70575c2f6ac7c9.png?width=800',
        lastMessage: 'こんにちは'),
    User(
        name: '加藤',
        uid: 'dfg',
        imagePath:
            'https://manabi.benesse.ne.jp/lab/student/study/__icsFiles/afieldfile/2021/03/29/pic-main_004_1.jpg',
        lastMessage: 'ありがとう')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャットアプリ'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SettingProfilePage())));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: ((context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (Context) =>
                            TalkRoomPage(userList[index].name)));
              },
              child: SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: userList[index].imagePath == null
                            ? null
                            : NetworkImage(userList[index].imagePath!),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userList[index].name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userList[index].lastMessage,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
