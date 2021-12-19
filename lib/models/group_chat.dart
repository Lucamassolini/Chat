
// ignore_for_file: empty_constructor_bodies

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/constants/constants.dart';

class GroupChat{
  String id;
  String nick;
  List<String> members;

  GroupChat({
    required this.id,
    required this.nick,
    required this.members,
  })

}