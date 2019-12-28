import 'package:flutter/material.dart';

import './filter_bar.dart';
import './model/restaurant.dart';
import './restaurant_grid.dart';
import './restaurant_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendlyEatsHomePage extends StatefulWidget {
  static const route = '/';

  FriendlyEatsHomePage({Key key}) : super(key: key);

  @override
  _FriendlyEatsHomePageState createState() => _FriendlyEatsHomePageState();
}

class _FriendlyEatsHomePageState extends State<FriendlyEatsHomePage> {
  _FriendlyEatsHomePageState() {
    FirebaseAuth.instance.signInAnonymously().then((AuthResult auth) {
      _loadAllRestaurants();
    });
  }

  bool _isLoading = true;
  List<Restaurant> _restaurants = <Restaurant>[];

  Stream<QuerySnapshot> _currentQuery;

  void _loadAllRestaurants() async {
    _currentQuery = Firestore.instance
        .collection('restaurants')
        .orderBy('avgRating', descending: true)
        .limit(50)
        .snapshots(includeMetadataChanges: true);
    _currentQuery.listen(_updateRestaurants);
  }

  void _updateRestaurants(QuerySnapshot snapshot) {
    setState(() {
      _isLoading = false;
      _restaurants = snapshot.documents.map((DocumentSnapshot doc) {
        return Restaurant.fromSnapshot(doc);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.restaurant),
        title: Text('FriendlyEats'),
        bottom: PreferredSize(
          preferredSize: Size(100, 36),
          child: FilterBar(
            onPressed: () {
              print('TODO: Select filters');
            },
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1280),
          child: _isLoading
              ? CircularProgressIndicator()
              : RestaurantGrid(
                  restaurants: _restaurants,
                  onRestaurantPressed: (id) {
                    // TODO: How can I get deep links on web?
                    Navigator.pushNamed(
                        context, FriendlyEatsRestaurantPage.route,
                        arguments: FriendlyEatsRestaurantPageArguments(id: id));
                  }),
        ),
      ),
    );
  }
}
