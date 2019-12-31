import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './empty_list.dart';
import './model/restaurant.dart';
import './model/review.dart';
import './restaurant_app_bar.dart';
import './restaurant_review.dart';
import './restaurant_review_dialog.dart';

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
          _restaurant.reference
              .collection('ratings')
              .orderBy('timestamp', descending: true)
              .snapshots()
              .listen((QuerySnapshot reviewSnap) {
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
  bool get _hasReviews => _reviews.isNotEmpty;

  Future<void> _addReview(String restaurantId, Review newReview) async {
    CollectionReference collection =
        Firestore.instance.collection('restaurants');
    DocumentReference restaurant = collection.document(restaurantId);
    DocumentReference review = restaurant.collection('ratings').document();
    String userId = await FirebaseAuth.instance
        .currentUser()
        .then((FirebaseUser user) => user.uid);

    return Firestore.instance.runTransaction((Transaction transaction) {
      return transaction
          .get(restaurant)
          .then((DocumentSnapshot freshRestaurantSnapshot) {
        Restaurant freshRestaurant =
            Restaurant.fromSnapshot(freshRestaurantSnapshot);
        double newAverage =
            ((freshRestaurant.numRatings * freshRestaurant.rating) +
                    newReview.rating) /
                (freshRestaurant.numRatings + 1);
        transaction.update(restaurant, {
          'numRatings': freshRestaurant.numRatings + 1,
          'avgRating': newAverage,
        });

        return transaction.set(review, {
          'rating': newReview.rating,
          'text': newReview.text,
          'userName': 'Anonymous (${kIsWeb ? "Web" : "Mobile"})',
          'timestamp': FieldValue.serverTimestamp(),
          'userId': userId,
        });
      });
    });
  }

  void _onCreateReviewPressed(BuildContext context) async {
    Review newReview = await showDialog<Review>(
        context: context, builder: (_) => RestaurantReviewDialog());
    if (newReview != null) {
      // Save the review
      return _addReview(_restaurant.id, newReview);
    }
  }

  void _onAddRandomReviewsPressed() async {
    // Await adding a random number of random reviews
    int numReviews = Random().nextInt(5) + 5;
    for (int i = 0; i < numReviews; i++) {
      await _addReview(_restaurant.id, Review.random());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              tooltip: 'Add a review',
              backgroundColor: Colors.amber,
              child: Icon(Icons.add),
              onPressed: () => _onCreateReviewPressed(context),
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                RestaurantAppBar(
                  restaurant: _restaurant,
                  onClosePressed: () => Navigator.pop(context),
                ),
                _reviews.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildListDelegate(_reviews
                            .map((Review review) =>
                                RestaurantReview(review: review))
                            .toList()),
                      )
                    : SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyListView(
                          child: Text('${_restaurant.name} has no reviews.'),
                          onPressed: _onAddRandomReviewsPressed,
                        )),
              ],
            ),
          );
  }
}

class FriendlyEatsRestaurantPageArguments {
  final String id;

  FriendlyEatsRestaurantPageArguments({@required this.id});
}
