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
import 'package:flutter/material.dart';

import './empty_list.dart';
import './filter_bar.dart';
import './filter_dialog.dart';
import './model/filter.dart';
import './model/data.dart' as data;
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
      _currentSubscription =
          data.loadAllRestaurants().listen(_updateRestaurants);
    });
  }

  @override
  void dispose() {
    _currentSubscription?.cancel();
    super.dispose();
  }

  StreamSubscription<QuerySnapshot> _currentSubscription;
  bool _isLoading = true;
  List<Restaurant> _restaurants = <Restaurant>[];
  Filter _filter;

  void _updateRestaurants(QuerySnapshot snapshot) {
    setState(() {
      _isLoading = false;
      _restaurants = data.getRestaurantsFromQuery(snapshot);
    });
  }

  Future<void> _onAddRandomRestaurantsPressed() {
    final numReviews = Random().nextInt(10) + 20;

    final restaurants = List.generate(numReviews, (_) => Restaurant.random());
    return data.addRestaurantsBatch(restaurants);
  }

  Future<void> _onFilterBarPressed() async {
    final filter = await showDialog<Filter>(
      context: context,
      builder: (_) => FilterDialog(filter: _filter),
    );
    if (filter != null) {
      await _currentSubscription?.cancel();
      setState(() {
        _isLoading = true;
        _filter = filter;
        if (filter.isDefault) {
          _currentSubscription =
              data.loadAllRestaurants().listen(_updateRestaurants);
        } else {
          _currentSubscription =
              data.loadFilteredRestaurants(filter).listen(_updateRestaurants);
        }
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
                        // TODO: Add deep links on web
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
