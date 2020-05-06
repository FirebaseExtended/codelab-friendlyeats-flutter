// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';

import './empty_list.dart';
import './model/data.dart' as data;
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
      data.getRestaurant(restaurantId).then((Restaurant restaurant) {
        _currentReviewSubscription?.cancel();
        setState(() {
          if (auth.user.displayName == null || auth.user.displayName.isEmpty) {
            _userName = 'Anonymous (${kIsWeb ? "Web" : "Mobile"})';
          } else {
            _userName = auth.user.displayName;
          }
          _restaurant = restaurant;
          _userId = auth.user.uid;

          // Initialize the reviews snapshot...
          _currentReviewSubscription = _restaurant.reference
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

  @override
  void dispose() {
    _currentReviewSubscription?.cancel();
    super.dispose();
  }

  bool _isLoading = true;
  StreamSubscription<QuerySnapshot> _currentReviewSubscription;

  Restaurant _restaurant;
  String _userId;
  String _userName;
  List<Review> _reviews = <Review>[];

  void _onCreateReviewPressed(BuildContext context) async {
    Review newReview = await showDialog<Review>(
      context: context,
      builder: (_) => RestaurantReviewDialog(
        userId: _userId,
        userName: _userName,
      ),
    );
    if (newReview != null) {
      // Save the review
      return data.addReview(
        restaurantId: _restaurant.id,
        review: newReview,
      );
    }
  }

  void _onAddRandomReviewsPressed() async {
    // Await adding a random number of random reviews
    int numReviews = Random().nextInt(5) + 5;
    for (int i = 0; i < numReviews; i++) {
      await data.addReview(
        restaurantId: _restaurant.id,
        review: Review.random(
          userId: _userId,
          userName: _userName,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Builder(
              builder: (context) => SliverFab(
                floatingWidget: FloatingActionButton(
                  tooltip: 'Add a review',
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.add),
                  onPressed: () => _onCreateReviewPressed(context),
                ),
                floatingPosition: FloatingPosition(right: 16),
                expandedHeight: RestaurantAppBar.kAppBarHeight,
                slivers: <Widget>[
                  RestaurantAppBar(
                    restaurant: _restaurant,
                    onClosePressed: () => Navigator.pop(context),
                  ),
                  _reviews.isNotEmpty
                      ? SliverPadding(
                          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(_reviews
                                .map((Review review) =>
                                    RestaurantReview(review: review))
                                .toList()),
                          ),
                        )
                      : SliverFillRemaining(
                          hasScrollBody: false,
                          child: EmptyListView(
                            child: Text('${_restaurant.name} has no reviews.'),
                            onPressed: _onAddRandomReviewsPressed,
                          ),
                        ),
                ],
              ),
            ),
          );
  }
}

class FriendlyEatsRestaurantPageArguments {
  final String id;

  FriendlyEatsRestaurantPageArguments({@required this.id});
}
