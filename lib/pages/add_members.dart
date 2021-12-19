// ignore_for_file: unused_field, unused_element

import 'package:chat/models/user_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({
    Key? key,
    required this.creator,
  }) : super(key: key);
  @override
  State createState() => AddMembersState();

  final String? creator;
}

class AddMembersState extends State<AddMembers> {
  late List<Object?> _selectedUsers;
  late UserChat uc;
  var markers = [];
  var ids = [];
  String nameGroup = '';
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf25f4c),
        title: const Text('Create group', style: TextStyle(
          color: Color(0xFF0f0e17),
                      
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        ),),
      ),
      body: Container(
          color: const Color(0xFF0f0e17),
          child: Column(
            
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Group name', style: TextStyle(
                  color: Color(0xFFf25f4c),
                  //backgroundColor : Color(0xFF0f0e17),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                ),textAlign: TextAlign.left,),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: TextFormField(
                    controller: myController,
                    obscureText: false,
                    
                    style: const TextStyle(
                      color: Color(0xFF0f0e17),
                      
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Color(0xFF0f0e17),
                        
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                      fillColor: Color(0xFFf25f4c),
                      filled: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Members', style: TextStyle(
                    color: Color(0xFFf25f4c),
                    //backgroundColor : Color(0xFF0f0e17),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),textAlign: TextAlign.start,),
              ),
              
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data?.docs.length ?? 0) > 0) {
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          uc = UserChat.fromDocument(snapshot.data!.docs[i]);
                          markers.add(uc.nickname);
                        }

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: MultiSelectDialogField(
                            items: markers
                                .map((e) => MultiSelectItem(e, e))
                                .toList(),
                            listType: MultiSelectListType.CHIP,
                            onConfirm: (values) {
                              _selectedUsers = values;
                            },
                            
                            buttonText: const Text('Add memebers', style: TextStyle(
                              color: Color(0xFF0f0e17),
                              //backgroundColor : Color(0xFF0f0e17),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),),
                            
                            decoration: BoxDecoration(
                              color: const Color(0xFFf25f4c),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text("No users"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              RaisedButton(
                  onPressed: () async {
                    ids.clear();
                    await FirebaseFirestore.instance
                        .collection('users')
                        .where('nickname', whereIn: _selectedUsers)
                        .get()
                        .then((QuerySnapshot query) {
                      query.docs.forEach((doc) {
                        ids.add(doc['id']);
                      });
                    });
                    await addGroups();
                  },
                  child: const Text('Create group', style: TextStyle(
                              color: Color(0xFFf25f4c),
                              
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),),
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFFf25f4c))
                ),
                            
              ),
                  
            ],
          )),
    );
  }

  addGroups() async {
    await FirebaseFirestore.instance.collection('groups').add({
      'createBy': widget.creator,
      'name': myController.text,
      'members': ids,
    });
  }
}
