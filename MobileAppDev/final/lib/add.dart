import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final _productNameCon = TextEditingController();
final _productPriceCon = TextEditingController();
final _productDescrip = TextEditingController();
late File _image;
bool _defaultImg = true;

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    String name;
    int price;
    String description;
    String url;

    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    Future<File> _fileFromImageUrl(Uri hgu) async {
      final response = await http.get(hgu);

      final documentDirectory = await getApplicationDocumentsDirectory();

      final file = File(join(documentDirectory.path, 'HGU.png'));

      file.writeAsBytesSync(response.bodyBytes);

      return file;
    }

    Future<String> fileToStorage() async {
      FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;

      var _url;
      print(_defaultImg);

      if (_defaultImg) {
        _url = "http://handong.edu/site/handong/res/img/logo.png";
        Uri myUri = Uri.parse(_url);
        Reference hguImg =
            firebaseStorageRef.ref().child('products').child('HGU');
        await hguImg.putFile(await _fileFromImageUrl(myUri));
      } else {
        String fileName = basename(_image.path);

        Reference refBS =
            firebaseStorageRef.ref().child('products').child(fileName);

        var uploadTask = await refBS.putFile(_image);

        _url = await uploadTask.ref.getDownloadURL();
      }
      return _url;
    }

    @override
    Future<void> addUser(String name, int price, String description) async {
      String url = (await fileToStorage()).toString();
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      // Call the user's CollectionReference to add a new user
      List<String> pLikeduserId = [];
      return products
          .add({
            'name': name,
            'price': price,
            'description': description,
            'url': url,
            'count': 0,
            'like': pLikeduserId,
            'created': FieldValue.serverTimestamp(),
            'creator': uid
          })
          .then((value) => print("Product Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

//final int id;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Add'),
        leading: TextButton(
          onPressed: () {
            _productDescrip.clear();
            _productNameCon.clear();
            _productPriceCon.clear();
            setState(() {
              _defaultImg = true;
            });

            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leadingWidth: 80,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              name = _productNameCon.text;
              price = int.parse(_productPriceCon.text);
              description = _productDescrip.text;

              addUser(name, price, description);
              setState(() {
                _defaultImg = true;
              });
              _productDescrip.clear();
              _productNameCon.clear();
              _productPriceCon.clear();

              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _AddInfo(),
    );
  }
}

class _AddInfo extends StatefulWidget {
  @override
  __AddInfoState createState() => __AddInfoState();
}

class __AddInfoState extends State<_AddInfo> {
  bool defaultImg = true;

  getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        defaultImg = false;
        _defaultImg = false;

        _image = File(image.path);
      } else {
        defaultImg = true;
        _defaultImg = true;
      }
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 400,
          height: 300,
          child: defaultImg
              ? Image.network(
                  'http://handong.edu/site/handong/res/img/logo.png')
              : Image.file(File(_image.path)),
        ),
        Container(
          alignment: Alignment.topRight,
          child: IconButton(
              onPressed: () {
                getGalleryImage();

                print(_defaultImg);
              },
              icon: Icon(Icons.camera)),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(children: [
              TextField(
                controller: _productNameCon,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              TextField(
                controller: _productPriceCon,
                decoration: const InputDecoration(
                  labelText: 'Product Price',
                ),
              ),
              TextField(
                controller: _productDescrip,
                decoration: const InputDecoration(
                  labelText: 'Product Description',
                ),
              ),
            ])),
      ],
    );
  }
}
