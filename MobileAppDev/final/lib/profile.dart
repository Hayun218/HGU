import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'home.dart';
import 'package:loading_animations/loading_animations.dart';

TextEditingController _msgCtrl = TextEditingController();

class MyProfile extends StatelessWidget {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  User user = FirebaseAuth.instance.currentUser!;

  Future signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      {
        Navigator.pop(context);
        Navigator.popUntil(context, ModalRoute.withName('/login'));
        print('Sign out');
        uid = "";
      }
    });
  }

  Future<DocumentSnapshot> _getUSR() async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => signOut(context)),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: _getUSR(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              print('${snapshot.error}');
              return const Text('Something went wrong');
            }
            if (!snapshot.hasData) {
              return LoadingFlipping.circle();
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            _msgCtrl =
                TextEditingController(text: data['status_message'].toString());

            return Container(
              margin: const EdgeInsets.fromLTRB(50, 20, 50, 30),
              child: Column(
                children: [
                  Center(
                    child: uid != 'n8aCdRclqMPplZgjAlAfGFYQPPh1'
                        ? Image.network(
                            'http://handong.edu/site/handong/res/img/logo.png',
                            fit: BoxFit.fill,
                            height: 230,
                            width: 230,
                          )
                        : Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/mad-final-bb9cc.appspot.com/o/profiles%2Fn8aCdRclqMPplZgjAlAfGFYQPPh1.jpg?alt=media&token=c83009fd-b755-4b5e-87d1-f046adba78fd',
                            fit: BoxFit.fill,
                            height: 300),
                  ),
                  const SizedBox(height: 60),
                  Text(uid,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const Divider(
                    height: 35,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  user.isAnonymous
                      ? const Text('Anonymous')
                      : Text(data['email']),
                  if (!user.isAnonymous) Text(data['name']),
                  const SizedBox(height: 40),
                  EditMsg(data: data, uid: uid),
                ],
              ),
            );
          }),
    );
  }
}

class EditMsg extends StatefulWidget {
  Map<String, dynamic> data;
  String uid;
  EditMsg({required this.data, required this.uid});
  @override
  _EditMsgState createState() => _EditMsgState();
}

class _EditMsgState extends State<EditMsg> {
  bool changeToField = false;
  bool isChangedMsg = false;

  Future updateMsg(String uid, String msg, BuildContext context) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).update({
      'status_message': msg,
    }).then((value) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/profile');
      print("updated");
      print(msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    var changes = EditProfileProvider(data: widget.data);

    return Column(
      children: [
        changeToField
            ? TextField(
                onChanged: (text) {
                  setState(() {
                    isChangedMsg = changes.isChanged();
                  });
                },
                maxLines: null,
                controller: _msgCtrl,
                style: const TextStyle(fontSize: 20))
            : Text(widget.data['status_message'],
                style: TextStyle(fontSize: 20)),
        const SizedBox(height: 40),
        TextButton(
          onPressed: () {
            setState(() {
              if (changeToField && isChangedMsg) {
                updateMsg(widget.uid, _msgCtrl.text, context);
              } else if (changeToField && !isChangedMsg) {
                changeToField = !changeToField;
              } else {
                changeToField = !changeToField;
              }
              print(changeToField);
            });
          },
          child: (isChangedMsg ? const Text('Save') : const Text('Edit')),
        ),
      ],
    );
  }
}

class EditProfileProvider extends ChangeNotifier {
  Map<String, dynamic> data;
  EditProfileProvider({required this.data});

  bool isChanged() {
    if (_msgCtrl.text != data['status_message']) {
      return true;
    } else {
      return false;
    }

    notifyListeners();
  }
}
