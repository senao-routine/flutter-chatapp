import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_udemy_chatapp02/firestore/room_firestore.dart';
import 'package:flutter_udemy_chatapp02/utils/shared_prefs.dart';

import '../model/user.dart';

class UserFirestore {
  static final FirebaseFirestore _firebaseFirestoreInstance =
      FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');

  static Future<String?> insertNewAccount() async {
    try {
      final newDoc = await _userCollection.add({
        'name': '名無し',
        'image_path':
            'https://assets.st-note.com/production/uploads/images/95747620/rectangle_large_type_2_657b16e7308ea52d7f70575c2f6ac7c9.png?width=800',
      });

      print('アカウント作成完了');
      return newDoc.id;
    } catch (e) {
      print('アカウント作成失敗 ==== $e');
      return null;
    }
  }

  static Future<void> createUser() async {
    final myUid = await UserFirestore.insertNewAccount();
    if (myUid != null) {
      await RoomFirestore.createRoom(myUid);
      await SharedPrefs.setUid(myUid);
    }
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async {
    try {
      final snapshot = await _userCollection.get();
      return snapshot.docs;
    } catch (e) {
      print('ユーザー情報の取得失敗 === $e');
      return null;
    }
  }

  static Future<User?> fetchProfile(String uid) async {
    try {
      final snapshot = await _userCollection.doc(uid).get();
      User user = User(
          name: snapshot.data()!['name'],
          imagePath: snapshot.data()!['image_path'],
          uid: uid);
      return user;
    } catch (e) {
      print('自分のユーザー情報の取得失敗 --- $e');
      return null;
    }
  }
}
