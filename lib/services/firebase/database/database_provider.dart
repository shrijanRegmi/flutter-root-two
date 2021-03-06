import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:root_two/models/firebase/user.dart';

class DatabaseProvider {
  final uid;
  DatabaseProvider({this.uid});

  final _ref = FirebaseFirestore.instance;
  static final _now = DateTime.now();
  final _currentDate = DateTime(_now.year, _now.month, _now.day);

  // send user details
  Future sendUserDetails({
    @required final String name,
    @required final String email,
  }) async {
    try {
      final _data = {
        'uid': uid,
        'name': name,
        'email': email,
        'light_bulbs': 5,
        'light_bulb_refills_at':
            _currentDate.add(Duration(days: 1)).millisecondsSinceEpoch,
      };

      await _ref.collection('users').doc(uid).set(_data);
      print('Success: Sending user details to firestore');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Sending user details to firestore');
      return null;
    }
  }

  // update user info
  Future updateUserInfo({
    final int level,
    final int points,
    final int lightBulbs,
    final int lightBulbRefillsAt,
    final bool hint,
    final bool solution,
  }) async {
    try {
      final _data = {
        'level': level,
        'points': points,
        'light_bulbs': lightBulbs,
        'light_bulb_refills_at': lightBulbRefillsAt,
        'hint': hint,
        'solution': solution,
      };

      _data.removeWhere((key, value) => value == null);
      await _ref.collection('users').doc(uid).update(_data);
      print('Success: Updating user details to firestore');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating user details to firestore');
      return null;
    }
  }

  // get user details
  AppUser _userFromFirebase(DocumentSnapshot<Map<String, dynamic>> ds) {
    return AppUser(
      uid: ds.data()['uid'] ?? '',
      userName: ds.data()['name'] ?? '',
      userEmail: ds.data()['email'] ?? '',
      level: ds.data()['level'] ?? 1,
      points: ds.data()['points'] ?? 0,
      lightBulbs: ds.data()['light_bulbs'] ?? 5,
      hint: ds.data()['hint'] ?? false,
      solution: ds.data()['solution'] ?? false,
      lightBulbRefillsAt: ds.data()['light_bulb_refills_at'],
    );
  }

  //get top players
  List<AppUser> _topPlayersFromFirebase(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((ds) {
      return AppUser(
        uid: ds.data()['uid'] ?? '',
        userName: ds.data()['name'] ?? '',
        userEmail: ds.data()['email'] ?? '',
        level: ds.data()['level'] ?? 1,
        points: ds.data()['points'] ?? 0,
      );
    }).toList();
  }

  // stream of users
  Stream<AppUser> get userDetail {
    try {
      return _ref
          .collection('users')
          .doc(uid)
          .snapshots()
          .map(_userFromFirebase);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<AppUser>> get topPlayerList {
    return _ref
        .collection('users')
        .limit(10)
        .orderBy('points', descending: true)
        .snapshots()
        .map(_topPlayersFromFirebase);
  }
}
