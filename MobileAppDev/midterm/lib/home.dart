import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'login.dart';

import 'detail.dart';

import 'package:url_launcher/url_launcher.dart';
import 'model/products_repository.dart';
import 'model/product.dart';

const _url = 'http://www.handong.edu/';

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HOME'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search,
                semanticLabel: 'search',
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.language,
                semanticLabel: 'language',
              ),
              onPressed: () => _launchURL(),
            ),
          ],
        ),
        drawer: _drawer(context),
        body: HomeView(),
        //resizeToAvoidBottomInset: false,
      ),
    );
  }
}

// drawer
Widget _drawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      // ignore: prefer_const_literals_to_create_immutables
      children: <Widget>[
        const DrawerHeader(
          child: Text(
            'Pages',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('Search'),
          onTap: () {
            Navigator.pushNamed(context, '/');
            Navigator.pushNamed(context, '/search');
          },
        ),
        ListTile(
          leading: const Icon(Icons.location_city),
          title: const Text('Favorite Hotel'),
          onTap: () {
            Navigator.pushNamed(context, '/');
            Navigator.pushNamed(context, '/favorite');
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('My Page'),
          onTap: () {
            Navigator.pushNamed(context, '/');
            Navigator.pushNamed(context, '/mypage');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log Out'),
          onTap: () {
            Navigator.pushNamed(context, '/');
            Navigator.pushNamed(context, '/login');
          },
        ),
      ],
    ),
  );
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
    itemSize: 15.0,
    direction: Axis.horizontal,
  );
}

List<Product> products = ProductsRepository.loadProducts();

List<Card> _buildGridCards(BuildContext context) {
  if (products.isEmpty) {
    return const <Card>[];
  }

  final ThemeData theme = Theme.of(context);

  return products.map((product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5, //그림자
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Wrap(
        // spacing: 8.0, // gap between adjacent chips
        // runSpacing: 4.0,
        children: <Widget>[
          Hero(
            tag: product.id,
            child: AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                product.assetName,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 10.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildStar(product.rating),
                Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.location,
                        style: theme.textTheme.caption,
                      ),
                    ),
                  ],
                ),
                _heroButton(context, product.id),
              ],
            ),
          ),
        ],
      ),
    );
  }).toList();
}

Widget _heroButton(context, int id) {
  return Container(
    alignment: Alignment.bottomRight,
    child: TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DetailPage(id: id)));
        },
        child: const Text('more')),
  );
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

final _isGridView = <bool>[false, true];

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.all(5),
              child: ToggleButtons(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  const Icon(Icons.menu),
                  const Icon(Icons.view_compact),
                ],
                isSelected: _isGridView,
                onPressed: (int index) {
                  setState(() {
                    // if condition 중복하지 않도록!
                    if (index == 0) {
                      _isGridView[0] = true;
                      _isGridView[1] = false;
                    } else if (index == 1) {
                      _isGridView[1] = true;
                      _isGridView[0] = false;
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: _isGridView[0] ? _ListView() : _OrientationList(),
            ),
          ],
        ),
      ),
    );
  }
}

//gridView with orientation
Widget _OrientationList() {
  return OrientationBuilder(
    builder: (context, orientation) {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
        padding: const EdgeInsets.all(16.0),
        childAspectRatio: 10.0 / 13.0,
        children: _buildGridCards(context),
      );
    },
  );
}

//gridView with orientation
Widget _ListView() {
  return ListView.builder(
    itemCount: products.length,
    shrinkWrap: true,
    padding: const EdgeInsets.all(16.0),
    itemBuilder: (BuildContext context, int index) {
      return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5, //그림자
          child: ListTile(
            leading: Hero(
              tag: index,
              child: AspectRatio(
                aspectRatio: 100 / 100,
                child: ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    products[index].assetName,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStar(products[index].rating),
                  SizedBox(height: 10),
                  Text(
                    products[index].name,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 10),
                  Text(
                    products[index].location,
                    style: TextStyle(fontSize: 12),
                  ),
                  _heroButton(context, index)
                ],
              ),
            ),
          ));
    },
  );
}
