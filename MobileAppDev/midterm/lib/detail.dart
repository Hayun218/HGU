import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'model/products_repository.dart';
import 'model/product.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:convert';

List<Product> product = ProductsRepository.loadProducts();
final _savedHotelNames = <String>[];

class DetailPage extends StatelessWidget {
  final int id;

  const DetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Detail'),
      ),
      body: _DetailPageBody(id: id),
    );
  }
}

class _DetailPageBody extends StatefulWidget {
  final int id;
  const _DetailPageBody({required this.id});
  @override
  __DetailPageBodyState createState() => __DetailPageBodyState();
}

class __DetailPageBodyState extends State<_DetailPageBody> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    String HotelName = product[widget.id].name;
    return ListView(
      children: [
        Hero(
          tag: widget.id,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onDoubleTap: () {
                setState(() {
                  _changeFavorite(HotelName);
                });
              },
              child: Stack(
                children: [
                  Image.asset(product[widget.id].assetName,
                      fit: BoxFit.fill, height: 300),
                  Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.all(20),
                      child: IconButton(
                          icon: _savedHotelNames.contains(HotelName)
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_border),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _changeFavorite(HotelName);
                            });
                          })),
                ],
              ),
            ),
          ),
        ),
        _DetaillView(widget.id),
      ],
    );
  }
}

void _changeFavorite(String _hotelName) {
  bool _isChecked = false;

  _savedHotelNames.contains(_hotelName)
      ? _isChecked = true
      : _isChecked = false;

  // 클릭할때마다
  _isChecked = !_isChecked;

  // 클릭하면 포함 아니면 제
  if (_isChecked) {
    _savedHotelNames.add(_hotelName);
  } else {
    _savedHotelNames.remove(_hotelName);
  }
}

// rating star
Widget _buildStar(double num) {
  return RatingBarIndicator(
    rating: num,
    itemBuilder: (context, index) => const Icon(
      Icons.star,
      color: Colors.yellow,
    ),
    itemCount: num.toInt(),
    itemSize: 30.0,
    direction: Axis.horizontal,
  );
}

Widget _DetaillView(int id) {
  Product productOne = product[id];
  return Container(
    margin: EdgeInsets.fromLTRB(30, 20, 30, 30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStar(productOne.rating),
        SizedBox(height: 10.0),
        AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText(
              productOne.name,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Agne'),
            ),
          ],
          totalRepeatCount: 1,
          displayFullTextOnTap: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.location_city,
            ),
            Text(productOne.location),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.phone,
            ),
            Text(productOne.phone),
          ],
        ),
        Divider(
          height: 50,
          thickness: 1,
          color: Colors.grey,
        ),
        Text(productOne.description),
      ],
    ),
  );
}

class FavoriteHotelPage extends StatefulWidget {
  @override
  _FavoriteHotelPageState createState() => _FavoriteHotelPageState();

  List<String> giveNames() {
    return _savedHotelNames;
  }
}

class _FavoriteHotelPageState extends State<FavoriteHotelPage> {
  @override
  Widget build(BuildContext context) {
    final tiles = _savedHotelNames.map(
      (String names) {
        return ListTile(
          title: Text(
            names,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Hotels'),
      ),
      body: ListView.separated(
        itemCount: _savedHotelNames.length,
        itemBuilder: (context, index) {
          final item = _savedHotelNames[index];
          return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                setState(() {
                  _savedHotelNames.removeAt(index);
                });

                // Then show a snackbar.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$item dismissed')));
              },
              background: Container(color: Colors.red),
              child: ListTile(title: Text(item)));
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: Colors.grey,
            height: 0,
          );
        },
      ),
    );
  }
}
