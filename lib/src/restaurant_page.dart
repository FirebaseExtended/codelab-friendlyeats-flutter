import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './model/restaurant.dart';
import './model/review.dart';
import './restaurant_app_bar.dart';
import './restaurant_review.dart';

class FriendlyEatsRestaurantPage extends StatefulWidget {
  static const route = '/restaurant';

  final String _restaurantId;

  FriendlyEatsRestaurantPage({Key key, @required String restaurantId})
      : _restaurantId = restaurantId,
        super(key: key);

  @override
  _FriendlyEatsRestaurantPageState createState() =>
      _FriendlyEatsRestaurantPageState(restaurantId: _restaurantId);
}

class _FriendlyEatsRestaurantPageState
    extends State<FriendlyEatsRestaurantPage> {
  _FriendlyEatsRestaurantPageState({@required String restaurantId}) {
    FirebaseAuth.instance.signInAnonymously().then((AuthResult auth) {
      // Load restaurant data (TODO: Move to snapshot() instead of get() to get live updates)
      Firestore.instance
          .collection('restaurants')
          .document(restaurantId)
          .snapshots()
          .listen((DocumentSnapshot snap) {
        setState(() {
          _restaurant = Restaurant.fromSnapshot(snap);
          // Initialize the reviews snapshot...
          _restaurant.reference.collection('ratings').orderBy('timestamp', descending: true).snapshots().listen(
            (QuerySnapshot reviewSnap) {
              setState(() {
              _isLoading = false;
              _reviews = reviewSnap.documents.map((DocumentSnapshot doc) {
                return Review.fromSnapshot(doc);
              }).toList();
            });
          });
        });
      });
    });
  }

  bool _isLoading = true;
  Restaurant _restaurant;
  List<Review> _reviews = <Review>[];

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LinearProgressIndicator()
        : Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              tooltip: 'Add a review',
              backgroundColor: Colors.amber,
              child: Icon(Icons.add),
              onPressed: () => print('tappity tap!'),
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                RestaurantAppBar(
                  restaurant: _restaurant,
                  onClosePressed: () => Navigator.pop(context),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    _reviews.map((Review review) => RestaurantReview(review: review)).toList()
                  ),
                ),
              ],
            ),
          );
  }
}

class FriendlyEatsRestaurantPageArguments {
  final String id;

  FriendlyEatsRestaurantPageArguments({@required this.id});
}
