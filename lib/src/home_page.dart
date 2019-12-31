import 'dart:math';

import 'package:flutter/material.dart';

import './filter_bar.dart';
import './model/restaurant.dart';
import './restaurant_grid.dart';
import './restaurant_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'empty_list.dart';

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

  Future<void> _addRestaurant(Restaurant restaurant) async {
    CollectionReference restaurants =
        Firestore.instance.collection('restaurants');
    return restaurants.add({
      'avgRating': 0,
      'category': restaurant.cuisine,
      'city': restaurant.location,
      'name': restaurant.name,
      'numRatings': 0,
      'photo': restaurant.imageUrl,
      'price': restaurant.price,
    });
  }

  void _onAddRandomRestaurantsPressed() async {
    // Await adding a random number of random reviews
    int numReviews = Random().nextInt(10) + 20;
    for (int i = 0; i < numReviews; i++) {
      await _addRestaurant(Restaurant.random());
    }
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
        child: Container(
          constraints: BoxConstraints(maxWidth: 1280),
          child: _isLoading
              ? CircularProgressIndicator()
              : _restaurants.isNotEmpty
                  ? RestaurantGrid(
                      restaurants: _restaurants,
                      onRestaurantPressed: (id) {
                        // TODO: How can I get deep links on web?
                        Navigator.pushNamed(
                            context, FriendlyEatsRestaurantPage.route,
                            arguments:
                                FriendlyEatsRestaurantPageArguments(id: id));
                      })
                  : EmptyListView(
                      child: Text('FriendlyEats has no restaurants yet!'),
                      onPressed: _onAddRandomRestaurantsPressed,
                    ),
        ),
      ),
    );
  }
}
