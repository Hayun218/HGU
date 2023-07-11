import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'home.dart';

class UpdateData extends StatefulWidget {
  final String docID;
  final Map<String, dynamic> data;
  UpdateData({required this.docID, required this.data});
  @override
  _UpdateDataState createState() => _UpdateDataState();
}

final String uid = FirebaseAuth.instance.currentUser!.uid;

class _UpdateDataState extends State<UpdateData> {
  late String name;
  late int price;
  late String description;
  late File _image;
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  bool changeImg = false;
  getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        changeImg = true;
        _image = File(image.path);
      } else {
        changeImg = false;
      }
    });
  }

  Future<String> fileToStorage() async {
    FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;

    print(changeImg);
    var _url;

    if (changeImg) {
      String fileName = basename(_image.path);

      Reference refBS =
          firebaseStorageRef.ref().child('products').child(fileName);

      var uploadTask = await refBS.putFile(_image);

      _url = await uploadTask.ref.getDownloadURL();
      return _url;
    }
    return _url;
  }

  Future updateProducts(
      String name, int price, String description, BuildContext context) async {
    String url = "";
    changeImg
        ? url = (await fileToStorage()).toString()
        : url = widget.data['url'];
    return products.doc(widget.docID).update({
      'name': name,
      'price': price,
      'description': description,
      'url': url,
      'modified': FieldValue.serverTimestamp(),
    }).then((value) {
      Navigator.pop(context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final _productNameCon = TextEditingController(text: widget.data['name']);
    final _productPriceCon =
        TextEditingController(text: widget.data['price'].toString());
    final _productDescrip =
        TextEditingController(text: widget.data['description']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leadingWidth: 70,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              name = _productNameCon.text;
              price = int.parse(_productPriceCon.text);
              description = _productDescrip.text;

              updateProducts(name, price, description, context);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  changeImg
                      ? Image.file(_image)
                      : Image.network(widget.data['url'],
                          fit: BoxFit.fill, height: 300),
                ],
              )),
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  getGalleryImage();
                },
                icon: Icon(Icons.camera)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _productNameCon,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Agne',
                        color: Colors.indigo),
                  ),
                  TextField(
                    controller: _productPriceCon,
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 8),
                  const Divider(
                    height: 50,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  TextField(
                    maxLines: null,
                    controller: _productDescrip,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
