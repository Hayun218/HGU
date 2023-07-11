import 'package:final_mad/edit.dart';
import 'package:final_mad/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'detail.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animations/loading_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = 'ASC';
  final appTxt = LoginProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            semanticLabel: 'profile',
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        title: appTxt.isGoogle(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'add',
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(13),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: DropdownButton(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['ASC', 'DESC']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Expanded(child: ProductCard(valueOrder: dropdownValue)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  String valueOrder;
  ProductCard({required this.valueOrder});
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Future<String> getImage(fileName) async {
    String downloadURL = firebase_storage.FirebaseStorage.instance
        .ref('products/$fileName')
        .getDownloadURL() as String;
    return downloadURL.toString();
  }

  final Stream<QuerySnapshot> _productsDES = FirebaseFirestore.instance
      .collection('products')
      .orderBy('price', descending: true)
      .snapshots();

  final Stream<QuerySnapshot> _productsASC = FirebaseFirestore.instance
      .collection('products')
      .orderBy('price', descending: false)
      .snapshots();
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);
    final isASC = DropDownProvider();

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: isASC.isACS(widget.valueOrder) ? _productsASC : _productsDES,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print('${snapshot.error}');
              return const Text('Something went wrong');
            }
            if (!snapshot.hasData) {
              return LoadingFlipping.circle();
            }

            return GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 18 / 10,
                          child: Image.network(
                            data['url'],
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 5.0, 16.0, 0.0),
                                child: SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          data['name'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(formatter.format(data['price'])),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailPage(
                                                            docID: document.id,
                                                            data: data,
                                                            uid: uid)));
                                          },
                                          child: Container(
                                              alignment: Alignment.bottomRight,
                                              child: const Text('more')),
                                        ),
                                      ]),
                                ))),
                      ],
                    ));
              }).toList(),
            );
          }),
    );
  }
}

class LoginProvider extends ChangeNotifier {
  Widget isGoogle() {
    final User currentUser = FirebaseAuth.instance.currentUser!;
    if (currentUser.isAnonymous) {
      return Text('Welcome Guest!');
    } else {
      String name = currentUser.displayName!;
      return Text("Welcome $name!");
    }
    notifyListeners();
  }
}

class DropDownProvider extends ChangeNotifier {
  bool isACS(String value) {
    if (value == 'ASC') {
      return true;
    } else {
      return false;
    }
    notifyListeners();
  }
}
