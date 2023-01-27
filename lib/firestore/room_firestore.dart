import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_udemy_chatapp02/firestore/user_firestore.dart';
import 'package:flutter_udemy_chatapp02/model/talk_room.dart';
import 'package:flutter_udemy_chatapp02/model/user.dart';
import 'package:flutter_udemy_chatapp02/utils/shared_prefs.dart';

class RoomFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _roomCollection = _firebaseFirestoreInstance.collection('room');

  static Future<void> createRoom(String myUid) async {
    try {
      final docs = await UserFirestore.fetchUsers();
      if (docs == null) return;

      docs.forEach((doc) async {
        if (doc.id == myUid) return;
        await _roomCollection.add({
          'joind_user_ids': [doc.id, myUid],
          'created_time': Timestamp.now()
        });
      });
    } catch (e) {
      print('ルームの作成に失敗 === $e');
    }
  }

  static Future<void> fetchJoindRooms() async {
    try {
      String myUid = SharedPrefs.fetchUid()!;
      final snapshot = await _roomCollection
          .where('joind_user_ids', arrayContains: myUid)
          .get();
      List<TalkRoom> talkRooms = [];
      for (var doc in snapshot.docs) {
        List<dynamic> userIds = doc.data()['joind_user_ids'];
        late String talkUserUid;
        for (var id in userIds) {
          if (id == myUid) continue;
          talkUserUid = id;
        }
        User? talkUser = await UserFirestore.fetchProfile(talkUserUid);
        if (talkUser == null) return;
        final talkRoom = TalkRoom(
            roomId: doc.id,
            talkUser: talkUser,
            lastMessage: doc.data()['last_message']);
        talkRooms.add(talkRoom);
      }

      print(talkRooms.length);
    } catch (e) {
      print('参加しているルームの取得失敗 === $e');
    }
  }
}
