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

import 'restaurant_page.dart';
import 'model/data.dart' as data;
import 'model/filter.dart';
import 'model/restaurant.dart';
import 'widgets/empty_list.dart';
import 'widgets/filter_bar.dart';
import 'widgets/grid.dart';
import 'widgets/dialogs/filter_select.dart';

class HomePage extends StatefulWidget {
  static const route = '/';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState() {
    FirebaseAuth.instance
        .signInAnonymously()
        .then((UserCredential userCredential) {
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

  Future<void> _onAddRandomRestaurantsPressed() async {
    final numReviews = Random().nextInt(10) + 20;

    final restaurants = List.generate(numReviews, (_) => Restaurant.random());
    data.addRestaurantsBatch(restaurants);
  }

  Future<void> _onFilterBarPressed() async {
    final filter = await showDialog<Filter>(
      context: context,
      builder: (_) => FilterSelectDialog(filter: _filter),
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
                        Navigator.pushNamed(context, RestaurantPage.route,
                            arguments: RestaurantPageArguments(id: id));
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
