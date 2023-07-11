import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'model/product.dart';
import 'model/products_repository.dart';
import 'detail.dart';

List<Product> product = ProductsRepository.loadProducts();

class MyPage extends StatelessWidget {
  List<String> favoriteNames = [];

  MyPage(this.favoriteNames);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My page'),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(30, 30, 30, 20),
            child: ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Lottie.asset('assets/images/sunset.json', height: 150),
            ),
          ),
          Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                'Hayun Park',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 5),
              const Text('21800325'),
            ],
          ),
          _ListViewBuilder(favoriteNames),
        ],
      ),
    );
  }
}

Widget _ListViewBuilder(List<String> names) {
  Iterable<Product> favoriteProducts = ProductsRepository.loadProducts()
      .where((Product p) => names.contains(p.name));

  List<Product> favorites = favoriteProducts.toList();

  return ListView.separated(
    physics: NeverScrollableScrollPhysics(),
    itemCount: favorites.length,
    shrinkWrap: true,
    padding: const EdgeInsets.all(16.0),
    itemBuilder: (BuildContext context, int index) {
      //if (index == 0) return SizedBox.shrink();
      return Card(
        semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5, //그림자
        child: Stack(
          children: [
            InkWell(
                child: ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    favorites[index].assetName,
                    fit: BoxFit.fill,
                  ),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(id: favorites[index].id)))),
            Container(
              margin: EdgeInsets.fromLTRB(20, 150, 10, 0),
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favorites[index].name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    favorites[index].location,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return SizedBox(height: 30);
    },
  );
}
