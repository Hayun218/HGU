// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new

import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

CollectionReference users = FirebaseFirestore.instance.collection('users');
User currentUser = FirebaseAuth.instance.currentUser!;

class _LoginPageState extends State<LoginPage> {
  late bool exist;

  Future<bool> checkExist(String docID) async {
    try {
      await users.doc(docID).get().then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

  void handleLogin(BuildContext context) async {
    UserCredential user = await AuthService.signInWithGoogle();
    // Here signInWithGoogle() is your defined function!

    final check = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (!check.exists) {
      await addUser().then((value) {
        print('added for google');
        Navigator.pushNamed(context, '/home');
      });
    } else {
      Navigator.pushNamed(context, '/home');
    }
  }

  void handleLoginAnon(BuildContext context) async {
    UserCredential user = await AuthService.signInAnon();
    // Here signInWithGoogle() is your defined function!

    await anonAddUser().then((value) {
      Navigator.pushNamed(context, '/home');
    });
  }

  Future<void> addUser() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final User currentUser = FirebaseAuth.instance.currentUser!;
    // Call the user's CollectionReference to add a new user

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
          'uid': uid,
          'status_message': 'I promise to take the test honestly before GOD.',
          'email': currentUser.email,
          'name': currentUser.displayName,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> anonAddUser() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
          'uid': uid,
          'status_message': 'I promise to take the test honestly before GOD.',
        })
        .then((value) => print("Anon User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                const SizedBox(height: 16.0),
                const Text('FINAL'),
              ],
            ),
            const SizedBox(height: 120.0),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  color: Colors.grey.withOpacity(0.3),
                  onPressed: () => handleLogin(context),
                  child: Text("Google Login"),
                ),
                RaisedButton(
                    color: Colors.grey.withOpacity(0.3),
                    child: Text("Guest Login"),
                    onPressed: () => handleLoginAnon(context))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
