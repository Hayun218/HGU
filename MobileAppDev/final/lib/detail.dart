import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_mad/edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:convert';

class DetailPage extends StatelessWidget {
  final String docID;
  final Map<String, dynamic> data;
  final String uid;

  DetailPage({required this.docID, required this.data, required this.uid});

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Future<void> deleteData() {
    return products
        .doc(docID)
        .delete()
        .then((value) => print("Data Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  late bool _editor;

  @override
  Widget build(BuildContext context) {
    if (uid == 'n8aCdRclqMPplZgjAlAfGFYQPPh1') {
      _editor = true;
    } else {
      _editor = false;
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Detail'),
        actions: [
          if (_editor)
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateData(docID: docID, data: data)))),
          if (_editor)
            IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteData();
                  Navigator.pop(context);
                }),
        ],
      ),
      body: _DetailPageBody(docID: docID, data: data),
    );
  }
}

int counter = 0;

class _DetailPageBody extends StatefulWidget {
  final String docID;
  final Map<String, dynamic> data;
  const _DetailPageBody({required this.docID, required this.data});
  @override
  __DetailPageBodyState createState() => __DetailPageBodyState();
}

class __DetailPageBodyState extends State<_DetailPageBody> {
  Future<void> _changeFavorite(
      String _docID, Map<String, dynamic> data, BuildContext context) async {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    List<dynamic> likes = data['like'];

    if (!data['like'].contains(uid)) {
      likes.add(uid);
      await products.doc(_docID).update({
        'like': likes,
        'count': data['count'],
      }).then((value) => print("like!"));
      const snackBar = SnackBar(
        content: Text('I LIKE IT!'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar2 = SnackBar(
        content: Text('You can only do it once!'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    bool _isChecked = false;
    counter = widget.data['count'];

    DateTime dateCreated = DateTime.now();
    DateTime dateModified = DateTime.now();
    if (widget.data['created'] != null) {
      dateCreated = (widget.data['created'] as Timestamp).toDate();
    }
    if (widget.data['modified'] != null) {
      dateModified = (widget.data['modified'] as Timestamp).toDate();
    }

    if (widget.data['like'].contains(uid)) {
      _isChecked = true;
    }
    return ListView(
      children: [
        Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Image.network(widget.data['url'],
                    fit: BoxFit.fill, height: 300),
              ],
            )),
        Container(
          margin: EdgeInsets.fromLTRB(30, 20, 30, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: [
                SizedBox(height: 10.0),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      widget.data['name'],
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Agne'),
                    ),
                  ],
                  totalRepeatCount: 1,
                  displayFullTextOnTap: true,
                ),
                IconButton(
                    icon: Icon(
                        _isChecked ? Icons.thumb_up : Icons.thumb_up_outlined),
                    color: Colors.red,
                    onPressed: () {
                      if (!widget.data['like'].contains(uid)) {
                        counter = (widget.data['count']) + 1;
                        widget.data['count'] = widget.data['count'] + 1;
                      }

                      _changeFavorite(widget.docID, widget.data, context);

                      setState(() {
                        if (widget.data['like'].contains(uid)) {
                          _isChecked = true;
                        } else {
                          widget.data['count'] = widget.data['count'] + 1;
                          _isChecked = false;
                        }

                        print(counter);
                      });
                    }),
                Text(counter.toString()),
              ]),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(formatter.format(widget.data['price'])),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(
                height: 50,
                thickness: 1,
                color: Colors.grey,
              ),
              Text(widget.data['description']),
              SizedBox(height: 150),
              Text(
                "Creator : " + widget.data['creator'],
                style: TextStyle(color: Colors.grey),
              ),
              if (widget.data['created'] != null)
                Text(dateCreated.toString() + "   Created",
                    style: TextStyle(color: Colors.grey)),
              if (widget.data['modified'] != null)
                Text(dateModified.toString() + "   Modified",
                    style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
