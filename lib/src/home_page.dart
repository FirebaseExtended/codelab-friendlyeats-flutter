import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './empty_list.dart';
import './filter_bar.dart';
import './filter_dialog.dart';
import './model/filter.dart';
import './model/restaurant.dart';
import './restaurant_grid.dart';
import './restaurant_page.dart';

class FriendlyEatsHomePage extends StatefulWidget {
  static const route = '/';

  FriendlyEatsHomePage({Key key}) : super(key: key);

  @override
  _FriendlyEatsHomePageState createState() => _FriendlyEatsHomePageState();
}

class _FriendlyEatsHomePageState extends State<FriendlyEatsHomePage> {
  _FriendlyEatsHomePageState() {
    FirebaseAuth.instance.signInAnonymously().then((AuthResult auth) {
      _query = _loadAllRestaurants();
      _query.listen(_updateRestaurants);
    });
  }

  Stream<QuerySnapshot> _query;

  bool _isLoading = true;
  List<Restaurant> _restaurants = <Restaurant>[];
  Filter _filter;

  Stream<QuerySnapshot> _loadAllRestaurants() {
    return Firestore.instance
        .collection('restaurants')
        .orderBy('avgRating', descending: true)
        .limit(50)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> _loadFilteredRestaurants(Filter filter) {
    Query collection = Firestore.instance.collection('restaurants');
    if (filter.cuisine != null) {
      collection = collection.where('category', isEqualTo: filter.cuisine);
    }
    if (filter.location != null) {
      collection = collection.where('city', isEqualTo: filter.location);
    }
    if (filter.price != null) {
      collection = collection.where('price', isEqualTo: filter.price);
    }
    return collection
        .orderBy(filter.sort ?? 'avgRating', descending: true)
        .limit(50)
        .snapshots();
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

  void _onFilterBarPressed() async {
    Filter filter = await showDialog<Filter>(
      context: context,
      builder: (_) => FilterDialog(filter: _filter),
    );
    if (filter != null) {
      setState(() {
        _isLoading = true;
        _filter = filter;
        if (filter.isDefault) {
          _query = _loadAllRestaurants();
        } else {
          _query = _loadFilteredRestaurants(filter);
        }
        _query.listen(_updateRestaurants);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.restaurant),
        title: Text('FriendlyEats'),
        bottom: PreferredSize(
          preferredSize: Size(320, 48),
          child: Padding(
            padding: EdgeInsets.fromLTRB(6, 0, 6, 4),
            child: FilterBar(
              filter: _filter,
              onPressed: _onFilterBarPressed,
            ),
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
