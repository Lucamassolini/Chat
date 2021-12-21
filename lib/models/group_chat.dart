// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/constants/constants.dart';

class GroupChat {
  String id;
  String nickname;
  List members;

  GroupChat(
      {required this.id,
      required this.nickname,
      required this.members});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.nickname: nickname,
      'members' : members,
    };
  }

  factory GroupChat.fromDocument(DocumentSnapshot doc) {
    List members =[];
    String nickname = "";
    try {
      members = doc.get('members');
    } catch (e) {}
    try {
      nickname = doc.get(FirestoreConstants.nickname);
    } catch (e) {}
    return GroupChat(
      id: doc.id,
      nickname: nickname,
      members: members,
    );
  }
}
